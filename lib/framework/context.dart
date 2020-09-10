import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
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
@JsonSerializable(nullable: false, createFactory: true, createToJson: true)
class ContextLevel extends Equatable {
  /// Contains the name of this level.
  @JsonKey(nullable: false, required: true)
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

/// [Context] identifies evrery bakecode contexts.
/// See BakeCode Environment MQTT Topic Documentation.
@immutable
class Context extends Equatable {
  /// Contains all the [ContextLevel]s in sequential order.
  final List<ContextLevel> levels;

  /// [path] gives the actual path to this service.
  String get path => levels.join('/');

  const Context._(List<ContextLevel> this.levels) : assert(levels != null);

  /// Creates a [Context] from the specified [levels].
  ///
  /// * `levels.first` should contain the root level.
  /// * `levels.last` should contain the farthest level from root.
  factory Context.fromLevels(List<ContextLevel> levels) => Context._(levels);

  /// Creates a [Context] for the specified [child] [ContextLevel] from
  /// [parentContext].
  factory Context.childFrom({
    @required Context parent,
    @required ContextLevel child,
  }) =>
      Context._(parent.levels.toList()..add(child));

  /// Creates a root [Context].
  factory Context.root(String root) => Context._([ContextLevel(root)]);

  /// [true] if this contains single level.
  bool get isRoot => levels.length == 1;

  /// Depth of this [Context] from root.
  ///
  /// **Example:**
  /// * Depth of `hw` in `bakecode/env/hw` is `2`.
  /// * Depth of `bakecode` in `bakecode/env/hw` is `0`.
  int get depth => levels.length - 1;

  /// [ContextLevel] of the root level.
  ContextLevel get rootLevel => levels.first;

  /// [ContextLevel] of the last level (farthest from root).
  ContextLevel get currentLevel => levels.last;

  /// Returns a new [Context] with a new child [level] appended to [levels].
  Context child(ContextLevel child) =>
      Context.childFrom(parent: this, child: child);

  /// Parent [Context] of this context.
  /// Returns `null` if this context is root.
  Context get parent =>
      isRoot ? null : Context.fromLevels(levels.sublist(0, depth));

  /// Equatable implementation.
  @override
  List<Object> get props => levels;

  /// Absolute path to this context as [String].
  @override
  String toString() => path;
}
