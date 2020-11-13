import 'package:meta/meta.dart';

// TODO: add certificate propoerty, secure TLS/SSL socket connection.

/// This class contains all parameters required for establishing a mqtt
/// connection to the broker.
@immutable
class MqttConnection {
  /// The brokers address.
  ///
  /// *Example:*
  /// ```dart
  /// var broker = "192.168.0.5";
  /// ```
  final String broker;

  /// Broker's listening port number.
  ///
  /// *Example:*
  /// ```dart
  /// var port = 1883;
  /// ```
  final int port;

  /// Broker authentication username.
  ///
  /// *Example:*
  /// ```dart
  /// var authentication_username = "admin";
  /// ```
  final String authentication_username;

  /// Broker authentication password.
  ///
  /// *Example:*
  /// ```dart
  /// var authentication_password = "bakecode is osum!";
  /// ```
  final String authentication_password;

  /// Create instance of MqttConnection from specified data.
  ///
  /// * Address of [broker]. eg: `"192.168.0.7"`.
  /// * MQTT broker's [port] number. default: `1883`.
  /// * Authentication credentials can be specified using
  /// [authentication_username] & [authentication_password].
  const MqttConnection.from({
    @required this.broker,
    this.port = 1883,
    this.authentication_username = '',
    this.authentication_password = '',
  });

  factory MqttConnection.fromMap(dynamic data) {
    try {
      return MqttConnection.from(
        broker: data['broker'],
        port: data['port'],
        authentication_username: data['username'],
        authentication_password: data['password'],
      );
    } catch (e) {
      throw FormatException(
          "Error reading MQTT configuration from Map<String, dynamic>", data);
    }
  }

  /// Returns true if authentication credentials are specified.
  bool get hasAuthentication =>
      authentication_username != '' || authentication_password != '';

  @override
  String toString() => """
  {
    "server": "$broker",
    "port": $port,
    "authentication_username": "$authentication_username",
    "authentication_password": "$authentication_password",
  }
  """;
}
