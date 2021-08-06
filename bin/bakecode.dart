import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:bakecode_engine/bakecode.dart' as bakecode;
import 'package:console/console.dart';
import 'package:pubspec_parse/pubspec_parse.dart';

Future<void> main(List<String> args) async {
  final runner = CommandRunner('bakecode', bakecode.description);

  runner.argParser.addFlag(
    'version',
    abbr: 'v',
    negatable: false,
    help: 'Prints the bakecode engine version.',
    callback: (wasParsed) {
      if (wasParsed) {}
    },
  );

  runner..addCommand(BakeCodeShell());

  await runner.run(args);
}

void _handleVersionCallback(bool wasParsed) {
  if (wasParsed) {
    final file = File('pubspec.yaml');

    if (!file.existsSync()) {
      stderr.writeln("Couldn't retrieve $file");
      exit(0);
    }

    final pubspec = Pubspec.parse(file.readAsStringSync());

    stdout.writeln('${pubspec.name} ${pubspec.version}');
    exit(0);
  }
}

class BakeCodeShell extends Command {
  @override
  String get name => 'shell';

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

  static void exit() {
    shell.stop();
  }
}
