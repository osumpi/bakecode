Map<K, V> mergeMap<K, V>(Iterable<Map<K, V>> maps) =>
    maps.fold<Map<K, V>>({}, (a, b) => _copyValues(a, b));

Map<K, V> _copyValues<K, V>(Map<K, V> from, Map<K, V> to) {
  for (final key in from.keys) {
    if (from[key] is Map<K, V>) {
      if (to[key] is! Map<K, V>) {
        to[key] = <K, V>{} as V;
      }
      _copyValues(from[key]! as Map, to[key]! as Map);
    } else {
      final value = from[key];
      if (value != null) to[key] = value;
    }
  }

  return to;
}
