import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// A handle to the location of a service in the bakecode service tree.
@immutable
class ServiceReference extends Equatable {
  /// The ServiceReference of the parent of this ServiceReference.
  ///
  /// Null if root.
  final ServiceReference parent;

  /// Name of the Service.
  ///
  /// For example:
  /// ```dart
  /// ('bakecode/eco/hw' as ServiceReference).name == 'hw';
  /// ```
  final String name;

  /// Creates a ServiceReference with a provided parent.
  ///
  /// `name` must follow MQTT single-level topic guidelines.
  /// * Should be short and concise.
  /// * Use only ASCII Characters, and avoid non-printable characters.
  /// * Should not contain spaces.
  /// * Should not use uncommon characters or any special characters.
  /// * Should not contain `/`.
  /// * Should be relevant to the [Service] layer.
  ///
  /// **Example:**
  /// ```dart
  /// class Dispenser extends Hardware {
  ///   @override
  ///   ServiceReference get ServiceReference => ServiceReference('dispenser', parent: super.ServiceReference);
  /// }
  /// ```
  ///
  /// If you want to create a root ServiceReference instead, use:
  /// ```dart
  /// var root = ServiceReference.root('bakecode');
  /// ```
  ServiceReference(this.name, {@required this.parent})
      : assert(name.contains('/') == false),
        assert(name.contains(' ') == false),
        assert(name != null) {
    all.add(this);
  }

  /// Creates a root ServiceReference.
  ///
  /// i.e., The created ServiceReference's parent shall be `null`.
  ///
  /// `root` must follow MQTT single-level topic guidelines.
  /// * Should be short and concise.
  /// * Use only ASCII Characters, and avoid non-printable characters.
  /// * Should not contain spaces.
  /// * Should not use uncommon characters or any special characters.
  /// * Should not contain `/`.
  /// * Should be relevant to the [Service] layer.
  ///
  /// **Example:**
  /// ```dart
  /// class BakeCode {
  ///   final ServiceReference = ServiceReference.root('bakecode');
  /// }
  /// ```
  ///
  /// If you want to create a ServiceReference with a parent instead, use the default
  /// **Example:**
  /// ```dart
  /// class Dispenser extends Hardware {
  ///   @override
  ///   ServiceReference get ServiceReference => ServiceReference('dispenser', parent: super.ServiceReference);
  /// }
  /// ```
  factory ServiceReference.root(String root) =>
      ServiceReference(root, parent: null);

  /// Creates an instance of ServiceReference from the specified string
  /// representation of the ServiceReference as the [path].
  ///
  /// i.e.,
  /// ```
  /// var ref = ServiceReference.fromString('bakecode/hw');
  /// print(ref.child('dispenser'));
  /// ```
  ///
  /// *Output:*
  /// `bakecode/hw/dispenser`
  ///
  /// `path` must follow MQTT topic guidelines.
  /// * Use only ASCII Characters, and avoid non-printable characters.
  /// * Should not contain spaces.
  /// * Should not use uncommon characters or any special characters.
  /// * Should be relevant to the [Service] layer.
  ///
  factory ServiceReference.fromString(String path) {
    var levels = path.split('/');

    var root = ServiceReference.root(levels[0]);

    if (levels.length == 1) return root;

    return levels
        .sublist(1)
        .fold<ServiceReference>(root, (parent, name) => parent.child(name));
  }

  /// Returns true if no parent exists.
  /// ```dart
  /// ('bakecode' as ServiceReference).isRoot == true;
  /// ('bakecode/eco/hw' as ServiceReference).isR`oot == false;
  /// ```
  bool get isRoot => parent == null;

  /// Depth from root.
  ///
  /// **Example:**
  /// ```dart
  /// ('bakecode/eco/hw' as ServiceReference).depth == 2;
  /// ('bakecode' as ServiceReference).depth == 0;
  /// ```
  int get depth => isRoot ? 0 : (parent.depth + 1);

  /// Root ServiceReference.
  ///
  /// i.e.,
  /// ```dart
  /// ('bakecode' as ServiceReference) == ('bakecode/eco/hw' as ServiceReference).root;
  /// ```
  ServiceReference get root => parent?.root ?? this;

  /// Returns the absolute path of this ServiceReference.
  ///
  /// Example:
  /// ```dart
  /// BakeCodeRuntime().ServiceReference.path == 'bakecode/runtime/141278932';
  /// ```
  String get path => isRoot ? name : '$parent/$name';

  /// Creates a child [ServiceReference] with this ServiceReference as the parent of the child.
  ///
  /// i.e.,
  /// ```dart
  /// ('bakecode' as ServiceReference).child('eco') == ('bakecode/eco' as ServiceReference);
  /// ```
  ServiceReference child(String child) => ServiceReference(child, parent: this);

  @override
  List<Object> get props => [path];

  /// Absolute path of the ServiceReference.
  ///
  /// **Example:**
  /// ```dart
  /// print(('bakecode/eco/hw' as ServiceReference));
  /// ```
  /// *Output:*
  /// `bakecode/eco/hw`
  @override
  String toString() => path;

  /// List of all instantiated ServiceReferences.
  static final List<ServiceReference> all = List<ServiceReference>();
}
