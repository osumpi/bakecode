part of bakecode.engine;

class BakecodeEngine extends Service {
  BakecodeEngine() : super(File('config/engine.yaml'));

  late final State<Ecosystem> ecosystem = state<Ecosystem>('map');

  @override
  Future<void> initState() async {
    super.initState();

    ecosystem.set(await Ecosystem.loadFromFile());
  }
}
