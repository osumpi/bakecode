library bakecode.engine;

import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:core/core.dart';
import 'package:pubspec_parse/pubspec_parse.dart';

part 'src/ecosystem.dart';
part 'src/engine.dart';

late final properties = Pubspec.parse(File('pubspec.yaml').readAsStringSync());

const description = """
BakeCode Ecosystem Engine.
See https://github.com/bakecode-devs/bakecode for more.

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
