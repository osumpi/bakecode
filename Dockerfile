# Bakecode Docker Image

# Command: docker build . -t bakecode:latest --file Dockerfile

FROM dart:latest

# Copy source, build bakecode and delete source

COPY . /bakecode

RUN cd /bakecode && dart pub get

RUN cd /bakecode && dart compile exe bin/bakecode.dart

RUN mv /bakecode/bin/bakecode.exe bakecode

RUN rm -rf /bakecode

# Server entry point

CMD [ "./bakecode" , "launch"]
