# Bakecode

[![Documentation](https://github.com/osumpi/bakecode/actions/workflows/generate_docs.yaml/badge.svg)](https://github.com/osumpi/bakecode/actions/workflows/generate_docs.yaml)

[![Build](https://github.com/osumpi/bakecode/actions/workflows/dart.yml/badge.svg)](https://github.com/osumpi/bakecode/actions/workflows/dart.yml)

## Setup

Bakecode requires `git`, `docker` and `dart` to be installed in the system.

```bash
git clone https://github.com/osumpi/bakecode.git
cd bakecode
pub get
pub run build_runner run --delete-conflicting-outputs
docker build . -t bakecode:latest --file Dockerfile.dev
```

## Usage

```bash
docker compose up
```
