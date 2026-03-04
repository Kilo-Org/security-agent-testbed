#!/usr/bin/env bash
set -euo pipefail

BASELINE_TAG="baseline"
MAIN_BRANCH="main"
REMOTE="origin"

usage() {
    cat <<EOF
Usage: ./reset.sh <command>

Commands:
  snapshot    Tag the current HEAD as the baseline state and push the tag to the remote.
  restore     Hard-reset main to the baseline tag, wipe all untracked files
              (including node_modules), and force-push to the remote.

Examples:
  ./reset.sh snapshot   # Run once to save the current state
  ./reset.sh restore    # Run after each test to reset everything
EOF
}

snapshot() {
    echo "==> Creating baseline snapshot..."

    # Warn if working tree is dirty
    if ! git diff --quiet || ! git diff --cached --quiet; then
        echo "WARNING: Working tree has uncommitted changes. Snapshotting HEAD anyway."
    fi

    local sha
    sha=$(git rev-parse --short HEAD)

    git tag -f "$BASELINE_TAG" HEAD
    echo "    Tagged HEAD ($sha) as '$BASELINE_TAG'"

    git push "$REMOTE" "$BASELINE_TAG" --force
    echo "    Pushed '$BASELINE_TAG' tag to $REMOTE"

    echo "==> Snapshot complete. Baseline is commit $sha."
}

restore() {
    # Verify baseline tag exists
    if ! git rev-parse "$BASELINE_TAG" >/dev/null 2>&1; then
        echo "ERROR: No '$BASELINE_TAG' tag found. Run './reset.sh snapshot' first."
        exit 1
    fi

    local baseline_sha
    baseline_sha=$(git rev-parse --short "$BASELINE_TAG")
    echo "==> Restoring to baseline ($baseline_sha)..."

    # Ensure we're on main
    echo "    Checking out $MAIN_BRANCH..."
    git checkout "$MAIN_BRANCH"

    # Hard-reset to the baseline tag
    echo "    Resetting to '$BASELINE_TAG'..."
    git reset --hard "$BASELINE_TAG"

    # Remove all untracked files and directories, including node_modules
    echo "    Cleaning untracked files (including node_modules)..."
    git clean -fdx

    # Force-push main to match the restored state
    echo "    Force-pushing $MAIN_BRANCH to $REMOTE..."
    git push "$REMOTE" "$MAIN_BRANCH" --force

    echo "==> Restore complete. $MAIN_BRANCH is now at baseline ($baseline_sha)."
    echo "    Run 'npm install --legacy-peer-deps' to reinstall dependencies."
}

# --- Main ---

if [[ $# -lt 1 ]]; then
    usage
    exit 1
fi

case "$1" in
    snapshot)
        snapshot
        ;;
    restore)
        restore
        ;;
    -h|--help|help)
        usage
        ;;
    *)
        echo "ERROR: Unknown command '$1'"
        echo
        usage
        exit 1
        ;;
esac
