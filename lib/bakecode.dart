library bakecode.engine;

import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

part 'src/ecosystem.dart';
part 'src/engine.dart';

part 'bakecode.g.dart';

const description = """
BakeCode Ecosystem Kernel. See https://github.com/crysalisdevs/bakecode for more.

Copyright (C) 2020, the BakeCode project authors.
This program comes with ABSOLUTELY NO WARRANTY; for details type 'show w'.
This is free software, and you are welcome to redistribute it
under certain conditions; type 'show c' for details.
""";

void log(String message, {Object? error, StackTrace? stackTrace}) => developer.log(
      message,
      time: DateTime.now(),
      name: "bakecode-engine",
      error: error,
      stackTrace: stackTrace,
    );


// final engine = BakeCodeEngine._createInstance();
