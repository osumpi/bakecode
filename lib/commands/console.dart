part of bakecode.engine;

class ConsoleCommand extends Command {
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
