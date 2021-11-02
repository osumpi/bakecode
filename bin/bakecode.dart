import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:bakecode/bakecode.dart';
import 'package:bakecode/logging.dart' as logger;
import 'package:intl/intl.dart';

Future<void> main(List<String> args) async {
  logger.initialize();

  final runner = CommandRunner('bakecode', description);

  runner.argParser.addFlag(
    'version',
    abbr: 'v',
    negatable: false,
    help: 'Print the BakeCode Engine version.',
    callback: (parsed) {
      if (parsed) {
        final buildDateFormat = DateFormat("E MMM d HH:mm:ss y 'UTC'");

        final platformName =
            Process.runSync('uname', ['-s']).stdout.toString().trim();
        final platformArchitecture =
            Process.runSync('uname', ['-m']).stdout.toString().trim();

        stdout.writeln(
            '${Pubspec.name} ${Pubspec.versionFull} ${buildDateFormat.format(Pubspec.buildDate)} on $platformName ($platformArchitecture)');
        exit(0);
      }
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
