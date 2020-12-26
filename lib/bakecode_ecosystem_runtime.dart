import 'package:bsi/bsi.dart';
import 'dart:developer' as developer;

class BakeCode extends Service {
  final isOnline = State('isOnline');

  BakeCode._() {
    // print('${record.level.name[0]}/${record.loggerName}: ${record.message}');
  }

  static final instance = BakeCode._();

  factory BakeCode() => instance;

  @override
  ServiceReference get reference => ServiceReference.root('bakecode');

  Future run() async {
    print('$reference is running...');

    onReceive.listen((message) {
      developer.log('$message', name: '$reference');
    });

    set({isOnline: true});
  }
}
