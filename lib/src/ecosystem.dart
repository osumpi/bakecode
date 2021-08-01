part of bakecode.engine;

@JsonSerializable(
  checked: true,
  disallowUnrecognizedKeys: true,
)
class Ecosystem {
  @JsonKey(
    fromJson: _$SerializableServiceFromJson,
    toJson: _$SerializableServiceToJson,
  )
  final _SerializableService root;

  Ecosystem({
    required this.root,
  });

  factory Ecosystem.dummy() {
    return Ecosystem(
      root: _SerializableService(
        name: 'bakecode',
        nodes: [
          _SerializableService(
            name: 'kitchen',
            nodes: [
              _SerializableService(
                name: 'storage',
                nodes: [
                  _SerializableService(
                    name: 'icy-resurrection',
                    nodes: [],
                  ),
                ],
              ),
            ],
          ),
          _SerializableService(
            name: 'dine-in',
            nodes: [
              _SerializableService(
                name: 'family-dine-in',
                nodes: [],
              ),
              _SerializableService(
                name: 'open-dine-in',
                nodes: [],
              ),
            ],
          ),
          _SerializableService(
            name: 'dine-out',
            nodes: [],
          ),
        ],
      ),
    );
  }

  factory Ecosystem.fromJson(Map<String, dynamic> json) =>
      _$EcosystemFromJson(json);

  static Future<Ecosystem> loadFrom([File? file]) async {
    file ??= File('config/ecosystem.json');

    if (!await file.exists()) {
      throw Exception('Unable to open file: `$file`');
    }

    final json = jsonDecode(await file.readAsString());

    if (json is! Map<String, dynamic>) {
      throw FormatException('Invalid format.', json);
    }

    return Ecosystem.fromJson(json);
  }

  Map<String, dynamic> toJson() => _$EcosystemToJson(this);
}

@JsonSerializable(
  checked: true,
  disallowUnrecognizedKeys: true,
)
class _SerializableService {
  final String name;

  final List<_SerializableService> nodes;

  _SerializableService({
    required this.name,
    required this.nodes,
  }) {
    if (name.isEmpty) {
      throw ArgumentError.value(name, 'name', 'Cannot be empty.');
    }
  }

  factory _SerializableService.fromJson(Map<String, dynamic> map) =>
      _$SerializableServiceFromJson(map);

  Map<String, dynamic> toJson() => _$SerializableServiceToJson(this);

  @override
  String toString() => name;
}
