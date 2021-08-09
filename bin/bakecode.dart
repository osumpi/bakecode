import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:bakecode_engine/bakecode.dart';
import 'package:console/console.dart';

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

class BakeCodeConsoleCommand extends Command {
  @override
  String get name => 'console';

  @override
  String get description => 'A REPL shell to access the engine.';

  @override
  void run() => (shell = ShellPrompt()).loop().listen(_dispatch);

  void _dispatch(String command) => registeredCommands[command]?.call();

  static late final ShellPrompt shell;

  static Map<String, Function()> registeredCommands = {
    'exit': exit,
    'quit': exit,
  };

  static void exit() => shell.stop();
}

class RunEngineCommand extends Command {
  @override
  String get name => 'run';

  @override
  String get description => 'Deploys and runs the bakecode engine in the ecosystem';

  @override
  Future run() => BakeCodeEngine.instance.initialize();
}
