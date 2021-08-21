import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:bakecode_engine/bakecode.dart';
import 'package:bakecode_engine/logging.dart' as logger;

Future<void> main(List<String> args) async {
  logger.initialize();

  final runner = CommandRunner('bakecode', description);

  runner.argParser.addFlag(
    'version',
    abbr: 'v',
    negatable: false,
    help: 'Print the BakeCode Engine version.',
    callback: (parsed) {
      if (!parsed) return;
      logger.log.config('bakecode $version');
      exit(0);
    },
  );

  runner
    // bakecode launch
    ..addCommand(LaunchEngineCommand())

    // bakecode console
    ..addCommand(ConsoleCommand())

    // bakecode recipes ...
    ..addCommand(RecipesCommand());

  await runner.run(args);
}
