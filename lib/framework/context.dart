import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// [ContextLevel] class just wraps a [String] [name].
/// This is so that, other [ContextPath]s which share the same level names,
/// can be referenced instead of duplicating the value.
///
/// [ContextLevel] identifies a single level, however does not have knowledge
/// about it's level / position. It's level / position gets meaning only
/// when used inside a [ContextPath].
///
/// **Example:**
/// The [ContextPath]: `bakecode/env/hw` has three [ContextLevel]s.
/// They are: `['bakecode', 'env', 'hw']`.
@immutable
class ContextLevel extends Equatable {
  /// Contains the name of this level.
  final String name;

  /// Creates a [ContextLevel].
  /// [name] is the name of this level.
  ///
  /// **Constraints:**
  /// * [name] should not contain `'/'`.
  ContextLevel(this.name)
      : assert(name != null),
        assert(name.contains('/') == false);

  /// Equatable implementation.
  @override
  List<Object> get props => [name];

  /// Returns the name of this level.
  @override
  String toString() => name;
}

/// A handle to the location of a service in the bakecode service tree.
///
/// This class presents a set of methods that can be used inside a bakecode
/// service.
@immutable
class Context extends Equatable {
  /// The parent of this context.
  ///
  /// Null if root.
  final Context parent;

  /// [ContextLevel] of this context.
  ///
  /// For example:
  /// ```dart
  /// ('bakecode/env/hw' as Context).me == ContextLevel('hw');
  /// ```
  final ContextLevel me;

  // /// Contains all the [ContextLevel]s in sequential order.
  // final List<ContextLevel> levels;

  /// Returns the absolute path of this context.
  ///
  /// Example:
  /// ```dart
  /// BakeCodeRuntime().context.path == 'bakecode/runtime/141278932';
  /// ```
  String get path => isRoot ? me : '$parent/me';

  /// Creates a context with a provided parent.
  ///
  /// **Example:**
  /// ```dart
  /// var context = Context(ContextLevel('env'), parent: root);
  /// ```
  ///
  /// If you want to create a root context instead, use:
  /// ```dart
  /// var root = Context.root('bakecode');
  /// ```
  const Context(this.me, {@required this.parent}) : assert(me != null);

  /// Creates a root context.
  ///
  /// i.e., The created context's parent shall be `null`.
  ///
  /// **Example:**
  /// ```dart
  /// var root = Context.root('bakecode');
  /// ```
  ///
  /// If you want to create a context with a parent instead, use the default
  /// constructor:
  /// ```dart
  /// var context = Context(ContextLevel('env'), parent: root);
  /// ```
  factory Context.root(String root) =>
      Context(ContextLevel(root), parent: null);

  /// Returns true if no parent exists.
  /// ```dart
  /// ('bakecode' as Context).isRoot == true;
  /// ('bakecode/env/hw' as Context).isRoot == false;
  /// ```
  bool get isRoot => parent == null;

  /// Depth from root.
  ///
  /// **Example:**
  /// ```dart
  /// ('bakecode/env/hw' as Context).depth == 2;
  /// ('bakecode' as Context).depth == 0;
  /// ```
  int get depth => isRoot ? 0 : (parent.depth + 1);

  /// Root context.
  ///
  /// i.e.,
  /// ```dart
  /// ('bakecode' as Context) == ('bakecode/env/hw' as Context).root;
  /// ```
  Context get root => isRoot ? this : parent.root;

  /// Creates a child [Context] with this context as the parent of the child.
  ///
  /// i.e.,
  /// ```dart
  /// ('bakecode' as Context).child('env') == ('bakecode/env' as Context);
  /// ```
  Context child(String child) => Context(ContextLevel(child), parent: this);

  @override
  List<Object> get props => [path];

  /// Absolute path of the context.
  ///
  /// **Example:**
  /// ```dart
  /// print(('bakecode/env/hw' as Context));
  /// ```
  /// *Output:*
  /// `bakecode/env/hw`
  @override
  String toString() => path;
}
