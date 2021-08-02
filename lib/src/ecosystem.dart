part of bakecode.engine;

///
@JsonSerializable(checked: true, disallowUnrecognizedKeys: true)
class Ecosystem {
  @JsonKey(fromJson: _$ServiceFromJson, toJson: _$ServiceToJson)
  final _Service root;

  @JsonKey(ignore: true)
  File? source;

  Ecosystem({required this.root});

  static Future<Ecosystem> loadFrom([String path = 'config/ecosystem.json']) async {
    final file = File(path);

    if (!await file.exists()) {
      throw Exception('`$file` does not exist.');
    }

    final json = jsonDecode(await file.readAsString());

    if (json is! Map<String, dynamic>) {
      throw FormatException('Invalid format.', json);
    }

    return _$EcosystemFromJson(json)..source = file;
  }

  static Future<void> saveTo([File? file]) async {}

  Map<String, dynamic> toJson() => _$EcosystemToJson(this);
}

@JsonSerializable(checked: true, disallowUnrecognizedKeys: true)
class _Service {
  final String name;

  final List<_Service> nodes;

  _Service({
    required this.name,
    required this.nodes,
  }) {
    if (name.isEmpty) {
      throw ArgumentError.value(name, 'name', 'Cannot be empty.');
    }
  }

  factory _Service.fromJson(Map<String, dynamic> map) => _$ServiceFromJson(map);

  Map<String, dynamic> toJson() => _$ServiceToJson(this);

  @override
  String toString() => name;
}
