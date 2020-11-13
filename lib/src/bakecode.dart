import 'package:bakecode/bakecode.dart';

class BakeCode extends Service {
  BakeCode._();

  static final instance = BakeCode._();

  factory BakeCode() => instance;

  @override
  void onReceive(String msg) => print(msg);

  @override
  ServiceReference get reference => ServiceReference.root('bakecode');

  Future run() async => await print('$reference is running...');
}
