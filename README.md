# Bakecode

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
