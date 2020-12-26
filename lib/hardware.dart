import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:bsi/bsi.dart';

abstract class Hardware extends Service {
  String get name;
  String get description;

  @override
  ServiceReference get reference => Services.Hardwares[name];

  final _instances = <HardwareInstance>[];

  Iterable<HardwareInstance> get instances => _instances;

  HardwareInstance createInstance(String id);
}

abstract class HardwareInstance<T extends Hardware> extends Service {
  T get hardware => _hardware;
  T _hardware;

  final String id;

  HardwareInstance(this.id) {
    hardware._instances.add(this);
  }

  @override
  void initState() {
    // super.initState();
  }

  @override
  ServiceReference get reference => hardware.reference[id];
  // TODO: add uuid
}

class SCARA extends Hardware {
  @override
  String get name => 'Dispenser';

  @override
  String get description =>
      "Dispense dispensable entities to a dispensable container";

  @override
  _SCARAInstance createInstance(String id) => _SCARAInstance(id);
}

class _SCARAInstance extends HardwareInstance<SCARA> {
  final isOnline = State('isOnline');

  _SCARAInstance(String id) : super(id) {
    hardware.instances;
    onReceive.listen((message) {
      final args = message.split(' ');

      CommandRunner('', '').run(args);
    });
  }
}

// abstract class Hardware {
//   void init();
// }

// @immutable
// abstract class HardwareType<T extends Hardware> {
//   String get name;

//   final instances = List<T>();
// }

// class Dispensers extends HardwareType<Dispenser> {
//   @override
//   String get name => 'Dispenser';
// }

// class Dispenser extends Hardware {
//   @override
//   void init() {
//     // TODO: implement init
//   }

//   /// Add all the specific functionalities here...
//   /// such as move(...), arm(...), reset(...), clear(...), hrst(...), dispense()...
//   /// stamp(...).
// }
