import 'package:bakecode_ecosystem_runtime/logging.dart';
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

  void handleEvent(String message) {
    log('Service \"$reference\" received command: \"$message\"');
  }

  Future run() async {
    log('Service \"$reference\" is running.');

    onReceive.listen(handleEvent);

    set({isOnline: true});
  }
}
