import 'package:bsi/bsi.dart';

class BakeCode extends Service {
  final isOnline = State('isOnline');

  BakeCode._();

  static final instance = BakeCode._();

  factory BakeCode() => instance;

  @override
  ServiceReference get reference => ServiceReference.root('bakecode');

  Future run() async {
    print('$reference is running...');

    onReceive.listen(print);

    set({isOnline: true});
  }
}
