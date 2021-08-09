import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:bakecode_engine/bakecode.dart';

Future<void> main(List<String> args) async {
  final runner = CommandRunner('bakecode', description);

  runner.argParser.addFlag(
    'version',
    abbr: 'v',
    negatable: false,
    help: 'Print the BakeCode Engine version.',
    callback: (parsed) {
      if (!parsed) return;

      stdout.writeln(version);
      exit(0);
    },
  );

  runner..addCommand(BakeCodeConsoleCommand())..addCommand(RunEngineCommand());

  await runner.run(args);
}
