import 'package:bakecode/bakecode.dart';

class BakeCode extends Service {
  BakeCode._() {
    onReceive.listen(print);
  }

  static final instance = BakeCode._();

  factory BakeCode() => instance;

  @override
  ServiceReference get reference => ServiceReference.root('bakecode');

  Future run() async => await print('$reference is running...');
}
