library bakecode.engine;

import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:bakecode/utils/merge_map.dart';
import 'package:bsi_dart/bsi.dart';
import 'package:console/console.dart';

part 'src/ecosystem.dart';

// All services
part 'services/engine.dart';

// All commands
part 'commands/launch.dart';
part 'commands/console.dart';
part 'commands/recipes.dart';

const version = '0.0.1-alpha';
const issueTracker = 'https://github.com/osumpi/bakecode/issues';
const repository = 'https://github.com/osumpi/bakecode';

const description = """

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
