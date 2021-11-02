# Bakecode

The bakecode ecosystem and service manager.

[![Bakecode Docker Image](https://github.com/osumpi/bakecode/actions/workflows/docker-image.yml/badge.svg)](https://github.com/osumpi/bakecode/actions/workflows/docker-image.yml)
[![Documentation](https://github.com/osumpi/bakecode/actions/workflows/generate_docs.yaml/badge.svg)](https://github.com/osumpi/bakecode/actions/workflows/generate_docs.yaml)
[![Dart Build](https://github.com/osumpi/bakecode/actions/workflows/dart.yml/badge.svg)](https://github.com/osumpi/bakecode/actions/workflows/dart.yml)
[![Docker Build](https://github.com/osumpi/bakecode/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/osumpi/bakecode/actions/workflows/docker-publish.yml)

## Setup

## Installation

Launch `bakecode` using docker's `compose` command.

```bash
mkdir bakecode
cd bakecode
wget https://raw.githubusercontent.com/osumpi/bakecode/main/docker-compose.yaml
docker compose up
```

### Local Docker setup

Bakecode requires `git`, `docker` and `dart` to be installed in the system.

```bash
git clone https://github.com/osumpi/bakecode.git
cd bakecode
docker build . --tag bakecode:latest --file Dockerfile
docker compose up
```

## Contributing

Launch your code editor of choice inside `bakecode:dev`. This is bakecode's
official development image.

```bash
git clone https://github.com/osumpi/bakecode.git
docker build bakecode --tag bakecode:dev --file Dockerfile.dev
```
