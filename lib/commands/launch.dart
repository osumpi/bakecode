part of bakecode.engine;

class LaunchEngineCommand extends Command {
  @override
  String get name => 'launch';

  @override
  String get description =>
      'Deploys and runs the bakecode engine in the ecosystem';

  @override
  Future<void> run() async {
    await BakecodeEngine.instance.initialize();
  }
}
