FROM google/dart

ENV DART_VERSION=2.9.3

WORKDIR /app

ADD pubspec.* /app/
RUN pub get
ADD . /app
RUN pub get --offline

CMD []
ENTRYPOINT ["/usr/bin/dart", "lib/main.dart"]
