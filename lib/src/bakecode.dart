import 'package:bakecode/bakecode.dart';
import 'package:bakecode/src/service/states.dart';

class BakeCode extends Service with States {
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
