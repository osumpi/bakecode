library bakecode.engine;

import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:console/console.dart';
import 'package:core/core.dart';
import 'package:pubspec_parse/pubspec_parse.dart';

part 'src/ecosystem.dart';

// All services
part 'services/engine.dart';

// All commands
part 'commands/launch.dart';
part 'commands/console.dart';
part 'commands/recipes.dart';

late final pubspec = _getPubspec();
late final version = pubspec.version;
late final issueTracker = pubspec.issueTracker;
late final repository = pubspec.repository;

late final description = """

BakeCode Ecosystem Engine.

See $repository for more.
See $issueTracker to report issues.

Copyright (C) 2020, the BakeCode project authors.
This program comes with ABSOLUTELY NO WARRANTY. This is free software, and you
are welcome to redistribute it under certain conditions.
""";

void log(String message, {Object? error, StackTrace? stackTrace}) =>
    developer.log(
      message,
      time: DateTime.now(),
      name: "bakecode-engine",
      error: error,
      stackTrace: stackTrace,
    );

Pubspec _getPubspec() {
  return Pubspec.parse(File('pubspec.yaml').readAsStringSync());
}
