# Security Agent Testbed

A Next.js project with intentionally vulnerable dependencies, designed as a testbed for security agents and vulnerability scanning tools.

## Purpose

This repository exists to provide a realistic environment for testing security tooling. The `package.json` includes pinned versions of popular npm packages that have known CVEs spanning a wide range of vulnerability categories:

- **Prototype Pollution** — lodash, minimist, json5, immer, protobufjs, xml2js, tough-cookie, json-schema, async, dompurify
- **ReDoS** — semver, highlight.js, normalize-url, luxon, ua-parser-js, minimatch, validator, word-wrap, ansi-regex, ws
- **XSS / Template Injection** — dompurify, handlebars, ejs, pug, marked, sanitize-html, send, webpack
- **SQL Injection** — sequelize, mysql2
- **SSRF** — axios, next, undici, webpack, got
- **Command Injection** — lodash, sharp, shelljs
- **Path Traversal** — moment, tar
- **Cryptographic Issues** — node-forge, crypto-js, jsonwebtoken, jose, nanoid
- **CRLF Injection** — undici
- **Authorization Bypass** — next
- **Session Fixation** — passport
- **Denial of Service** — body-parser, next, tar, undici, qs

Some packages (e.g. `request`, `ip`) have no fix available, which tests a security agent's ability to recommend alternative packages rather than simple version bumps.

## Vulnerability Summary

| Severity | Count |
|----------|-------|
| Critical | 17    |
| High     | 32    |
| Moderate | 18    |
| Low      | 4     |
| **Total**| **71**|

Run `npm audit` after installing to see the full report.

## Setup

```bash
npm install --legacy-peer-deps
```

The `--legacy-peer-deps` flag is needed because some older package versions have conflicting peer dependency requirements.

## Usage

This project is not intended to be run as a real application. Its value is in the dependency tree. Typical usage:

```bash
# View all vulnerabilities
npm audit

# Test your security agent against this repo
your-security-agent scan .
```

## Warning

**Do not use this project or its dependency versions in production.** Every dependency version was chosen specifically because it contains known security vulnerabilities.
