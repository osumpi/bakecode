import 'dart:convert';

import 'package:bsi_dart/bsi_dart.dart';

class BakeCode extends Service {
  BakeCode._();

  static final instance = BakeCode._();

  factory BakeCode() => instance;

  @override
  ServiceReference get reference => ServiceReference.root('bakecode');

  Future run() async {
    print('$reference is running...');

    onReceive.listen((m) {
      try {
        var hwmap = jsonDecode(m.message);
        print(hwmap);
      } catch (e) {
        print(e);
      }
    });
    notify(reference, message: 'online');
    broadcast('online');
  }
}
