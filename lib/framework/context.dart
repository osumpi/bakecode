import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

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

  /// Name of this context.
  ///
  /// For example:
  /// ```dart
  /// ('bakecode/eco/hw' as Context).name =='hw';
  /// ```
  final String name;

  /// Creates a context with a provided parent.
  ///
  /// `name` must follow MQTT single-level topic guidelines.
  /// * Should be short and concise.
  /// * Use only ASCII Characters, and avoid non-printable characters.
  /// * Should not contain spaces.
  /// * Should not use uncommon characters or any special characters.
  /// * Should not contain `/`.
  /// * Should be relevant to the service / context layer.
  ///
  /// **Example:**
  /// ```dart
  /// class Dispenser extends Hardware {
  ///   @override
  ///   Context get context => Context('dispenser', parent: super.context);
  /// }
  /// ```
  ///
  /// If you want to create a root context instead, use:
  /// ```dart
  /// var root = Context.root('bakecode');
  /// ```
  Context(this.name, {@required this.parent})
      : assert(name.contains('/') == false),
        assert(name.contains(' ') == false),
        assert(name != null);

  /// Creates a root context.
  ///
  /// i.e., The created context's parent shall be `null`.
  ///
  /// `root` must follow MQTT single-level topic guidelines.
  /// * Should be short and concise.
  /// * Use only ASCII Characters, and avoid non-printable characters.
  /// * Should not contain spaces.
  /// * Should not use uncommon characters or any special characters.
  /// * Should not contain `/`.
  /// * Should be relevant to the service / context layer.
  ///
  /// **Example:**
  /// ```dart
  /// class BakeCode {
  ///   final context = Context.root('bakecode');
  /// }
  /// ```
  ///
  /// If you want to create a context with a parent instead, use the default
  /// **Example:**
  /// ```dart
  /// class Dispenser extends Hardware {
  ///   @override
  ///   Context get context => Context('dispenser', parent: super.context);
  /// }
  /// ```
  factory Context.root(String root) => Context(root, parent: null);

  /// Returns true if no parent exists.
  /// ```dart
  /// ('bakecode' as Context).isRoot == true;
  /// ('bakecode/eco/hw' as Context).isRoot == false;
  /// ```
  bool get isRoot => parent == null;

  /// Depth from root.
  ///
  /// **Example:**
  /// ```dart
  /// ('bakecode/eco/hw' as Context).depth == 2;
  /// ('bakecode' as Context).depth == 0;
  /// ```
  int get depth => isRoot ? 0 : (parent.depth + 1);

  /// Root context.
  ///
  /// i.e.,
  /// ```dart
  /// ('bakecode' as Context) == ('bakecode/eco/hw' as Context).root;
  /// ```
  Context get root => parent?.root ?? this;

  /// Returns the absolute path of this context.
  ///
  /// Example:
  /// ```dart
  /// BakeCodeRuntime().context.path == 'bakecode/runtime/141278932';
  /// ```
  String get path => isRoot ? name : '$parent/$name';

  /// Creates a child [Context] with this context as the parent of the child.
  ///
  /// i.e.,
  /// ```dart
  /// ('bakecode' as Context).child('eco') == ('bakecode/eco' as Context);
  /// ```
  Context child(String child) => Context(child, parent: this);

  @override
  List<Object> get props => [path];

  /// Absolute path of the context.
  ///
  /// **Example:**
  /// ```dart
  /// print(('bakecode/eco/hw' as Context));
  /// ```
  /// *Output:*
  /// `bakecode/eco/hw`
  @override
  String toString() => path;
}
