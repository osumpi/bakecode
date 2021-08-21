part of bakecode.engine;

class BakecodeEngine extends Service {
  BakecodeEngine.createInstance() : super(File('config/engine.yaml'));

  static final instance = BakecodeEngine.createInstance();

  late final Ecosystem ecosystem;

  late final State<String> tree = state<String>('tree');

  @override
  Future<void> initState() async {
    super.initState();

    runner.addCommand(_InstantiatedCommand());

    ecosystem = await Ecosystem.loadFromFile();
    tree.set(jsonEncode(ecosystem));
  }

  @override
  void onMessageReceived(ServiceMessage message) {
    super.onMessageReceived(message);

    try {
      runner.run(message.arguments);
    } catch (exception) {
      log('$exception');
    }
  }

  late final runner = CommandRunner(config.name, config.description);
}

class _InstantiatedCommand extends Command {
  @override
  final name = 'instantiated';
  @override
  final description = '';

  _InstantiatedCommand() {
    addSubcommand(_InstantiatedServiceCommand());
  }
}

class _InstantiatedServiceCommand extends Command {
  @override
  final name = 'service';

  @override
  final description = '';

  _InstantiatedServiceCommand() {
    argParser.addOption('name', mandatory: true);
    argParser.addOption('id', mandatory: true);
    argParser.addOption('address', mandatory: true);
  }

  @override
  Future<void> run() async {
    final name = argResults!['name'] as String;
    final id = argResults!['id'] as String;
    final address = Address(argResults!['address'] as String);

    await BakecodeEngine.instance.ecosystem.addService(address, id);

    BakecodeEngine.instance.tree.set(
      jsonEncode(BakecodeEngine.instance.ecosystem),
    );
  }
}
