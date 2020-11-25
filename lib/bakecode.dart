import 'package:bsi_dart/bsi_dart.dart';

class BakeCode extends Service {
  BakeCode._();

  static final instance = BakeCode._();

  factory BakeCode() => instance;

  @override
  ServiceReference get reference => ServiceReference.root('bakecode');

  Future run() async {
    print('$reference is running...');

    onReceive.listen(print);
    notify(reference, message: 'online');
    broadcast('online');
  }
}
