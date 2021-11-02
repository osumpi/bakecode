# Bakecode

The bakecode ecosystem and service manager.

[![Docker Build](https://github.com/osumpi/bakecode/actions/workflows/docker-image.yaml/badge.svg)](https://github.com/osumpi/bakecode/actions/workflows/docker-image.yaml)
[![Documentation](https://github.com/osumpi/bakecode/actions/workflows/generate_docs.yaml/badge.svg)](https://github.com/osumpi/bakecode/actions/workflows/generate_docs.yaml)
[![Dart Build](https://github.com/osumpi/bakecode/actions/workflows/dart.yaml/badge.svg)](https://github.com/osumpi/bakecode/actions/workflows/dart.yaml)

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

### Code generations

```sh
dart pub global activate pubspec_extract
dart pub global run pubspec_extract -d lib/pubspec.g.dart
```

## Contributing

Launch your code editor of choice inside `bakecode:dev`. This is bakecode's
official development image.

```bash
git clone https://github.com/osumpi/bakecode.git
docker build bakecode --tag bakecode:dev --file Dockerfile.dev
```

```sh
dart pub global activate pubspec_extract
dart pub global run pubspec_extract -d lib/pubspec.g.dart
```
