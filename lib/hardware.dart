import 'package:meta/meta.dart';

abstract class Hardware {
  void init();
}

@immutable
abstract class HardwareType<T extends Hardware> {
  String get name;

  final instances = List<T>();
}

class Dispensers extends HardwareType<Dispenser> {
  @override
  String get name => 'Dispenser';
}

class Dispenser extends Hardware {
  @override
  void init() {
    // TODO: implement init
  }

  /// Add all the specific functionalities here...
  /// such as move(...), arm(...), reset(...), clear(...), hrst(...), dispense()...
  /// stamp(...).
}
