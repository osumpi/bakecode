import 'package:bakecode/framework/bakecode.dart';

main() async {
  await BakeCodeRuntime.instance.run();
  BakeCodeRuntime.instance.publish('a');
  BakeCode.instance.publish('sd');
}
