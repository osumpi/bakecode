# syntax = edrevo/dockerfile-plus
# Bakecode Docker Image

# Command: docker build . -t bakecode:latest --file Dockerfile

FROM dart:latest

# Copy Source & Setup

INCLUDE+ Dockerfile.dev

RUN cd /bakecode && dart analyze

# Build Bakecode

RUN cd /bakecode && dart compile exe bin/bakecode.dart

RUN mv /bakecode/bin/bakecode.exe bakecode

# Clean up by removing source

RUN rm -rf /bakecode

# Server entry point

CMD [ "./bakecode" , "launch"]
