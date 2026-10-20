# Security Agent Testbed

> [!WARNING]
> **Do not use this project or its remaining unpatched dependency versions in production.** Many packages are still pinned to versions with known CVEs. Selected critical issues have been patched as listed below.

A Next.js project used as a testbed for security agents and vulnerability scanning tools. Critical CVEs in several pinned packages have been upgraded; other known-vulnerable versions remain.

## Purpose

This repository provides a realistic environment for testing security tooling. `package.json` still pins many popular npm packages with known CVEs. The following **critical** issues have been patched:

| Package | From | To | Issue |
|---------|------|----|-------|
| `underscore` | 1.12.0 | 1.12.1 | Arbitrary code execution (CVE-2021-23358) |
| `minimist` | 1.2.5 | 1.2.6 | Prototype pollution (CVE-2021-44906) |
| `handlebars` | 4.7.6 | 4.7.10 | Prototype pollution and AST type-confusion RCE |
| `next` | 13.4.0 | 13.5.9 | Middleware authorization bypass (CVE-2025-29927) |
| `eslint-config-next` | 13.4.0 | 13.5.9 | Peer alignment with Next.js 13.5.9 |
| `mongoose` | 5.13.0 | 6.13.10 | Prototype pollution and search injection |
| `tar` | 6.1.0 | 7.5.19 | Decompression/parse DoS (CVE-2026-59873) |
| `protobufjs` | 6.11.2 | 6.11.4 | Prototype pollution (CVE-2023-36665) |
| `crypto-js` | 4.1.1 | 4.2.0 | Weak PBKDF2 defaults (CVE-2023-46233) |
| `json-schema` | 0.2.3 | 0.4.0 | Prototype pollution (CVE-2021-3918) |
| `loader-utils` | 2.0.2 | 2.0.3 | Prototype pollution (CVE-2022-37601) |
| `immer` | 9.0.5 | 9.0.6 | Prototype pollution (CVE-2021-3757) |

Remaining categories still represented by unpatched pins include:

- **Prototype Pollution** — lodash, json5, xml2js, tough-cookie, async, dompurify
- **ReDoS** — semver, highlight.js, normalize-url, luxon, ua-parser-js, minimatch, validator, word-wrap, ansi-regex, ws
- **XSS / Template Injection** — dompurify, ejs, pug, marked, sanitize-html, webpack
- **SQL Injection** — sequelize, mysql2
- **SSRF** — axios, next, undici, webpack, got
- **Command Injection** — lodash, sharp, shelljs
- **Path Traversal** — moment
- **Cryptographic Issues** — node-forge, jsonwebtoken, jose, nanoid
- **CRLF Injection** — undici
- **Session Fixation** — passport
- **Denial of Service** — body-parser, next, undici, qs

Some packages (e.g. `request`, `ip`) have no fix available, which tests a security agent's ability to recommend alternative packages rather than simple version bumps.

Install and production build were verified after these upgrades (`npm install --legacy-peer-deps`, `npx next build`).

## Vulnerability Summary

Current `npm audit` after the patches above:

| Severity | Count |
|----------|-------|
| Critical | 10    |
| High     | 52    |
| Moderate | 14    |
| Low      | 4     |
| **Total**| **80**|

Run `npm audit` after installing to see the full report.

## Setup

```bash
npm install --legacy-peer-deps
```

The `--legacy-peer-deps` flag is needed because some older package versions have conflicting peer dependency requirements.

## Resetting the Testbed

Since security agents will modify this repo (updating dependencies, applying patches, etc.), a reset mechanism is included to restore the repo to its original vulnerable state for repeated testing.

### Initial setup (one time)

After cloning and before running any security agent, snapshot the current state:

```bash
./reset.sh snapshot
```

This creates a `baseline` git tag at the current commit and pushes it to the remote.

### After each test run

To restore the repo to its original state:

```bash
./reset.sh restore
```

This will:
1. Hard-reset `main` to the `baseline` tag
2. Remove **all** untracked files and directories (including `node_modules`)
3. Force-push `main` to the remote

After restoring, reinstall dependencies:

```bash
npm install --legacy-peer-deps
```

## Usage

This project is not intended to be run as a real application. Its value is in the dependency tree. Typical usage:

```bash
# View all vulnerabilities
npm audit

# Test your security agent against this repo
your-security-agent scan .
```
