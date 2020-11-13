import 'package:bakecode/bakecode.dart';

class BroadcastService extends Service {
  BroadcastService._();

  static final instance = BroadcastService._();

  factory BroadcastService() => instance;

  @override
  ServiceReference get reference => BakeCode().reference.child('broadcast');

  Stream<ServiceMessage> get publicServiceAnnouncement =>
      onReceive.asBroadcastStream();
}
