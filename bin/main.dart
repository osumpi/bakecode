// import 'package:bakecode/framework/bakecode.dart';

// void main() => BakeCodeRuntime.instance.run();

import 'package:bakecode/framework/context.dart';

main() {
  Context a = Context.root('root');
  print(a);

  Context a1 = Context.childFrom(parent: a, child: ContextLevel('c1'));
  print(a);
  print(a1);
  print(a1.parent);
  print(a1.depth);
}
