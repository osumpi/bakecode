import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:bakecode_engine/bakecode.dart';

import 'package:bakecode_engine/logging.dart' as logger;
import 'package:core/core.dart';

Future<void> main(List<String> args) async {
  logger.initialize();

  final ecosystem = await Ecosystem.loadFromFile();

  ecosystem.merge(
      Address('something/inside/led'), 'ea3b800f-f148-41ff-b558-e4807f13ce63');

  print(const JsonEncoder.withIndent('  ').convert(ecosystem));

  //Ecosystem.recursivelyAddValue()

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
