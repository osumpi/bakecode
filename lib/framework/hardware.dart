import 'package:meta/meta.dart';

@immutable
abstract class HardwareService {
  static final allServices = List<HardwareService>();

  String get name;

  final List<HardwareInstance> instances = const [];

  HardwareInstance createInstance();

  HardwareService() {
    allServices.add(this);
  }
}

abstract class HardwareInstance<T extends HardwareService> {
  T get hardware;

  /// Add the general specific stuff here..
  void init();
}

/// This is a singleton service class...
class Dispenser extends HardwareService {
  @override
  String get name => 'dispenser';

  @override
  DispenserInstance createInstance() => DispenserInstance();

  Dispenser._();

  static final service = Dispenser._();

  factory Dispenser() => service;
}

/// This is an instantiable hardware service class.
class DispenserInstance extends HardwareInstance<Dispenser> {
  @override
  void init() {
    // generate "byte-like-codes" here and register them...?
    // invoked by Dispenser.createState();
  }

  /// Add all the specific functionalities here...
  /// such as move(...), arm(...), reset(...), clear(...), hrst(...), dispense()...
  /// stamp(...).
}
