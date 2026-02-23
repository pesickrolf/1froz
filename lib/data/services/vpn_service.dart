import 'package:flutter/services.dart';
import '../../domain/models/vpn_status.dart';

class VpnService {
  static const platform = MethodChannel('com.froz.vpn/service');

  Future<bool> connect(String config) async {
    try {
      final result = await platform.invokeMethod('connect', {'config': config});
      return result as bool;
    } catch (e) {
      return false;
    }
  }

  Future<bool> disconnect() async {
    try {
      final result = await platform.invokeMethod('disconnect');
      return result as bool;
    } catch (e) {
      return false;
    }
  }

  Stream<VpnStatus> get statusStream {
    return const EventChannel('com.froz.vpn/status')
        .receiveBroadcastStream()
        .map((event) => _parseStatus(event as String));
  }

  VpnStatus _parseStatus(String status) {
    switch (status) {
      case 'connected':
        return VpnStatus.connected;
      case 'connecting':
        return VpnStatus.connecting;
      case 'disconnecting':
        return VpnStatus.disconnecting;
      case 'error':
        return VpnStatus.error;
      default:
        return VpnStatus.disconnected;
    }
  }

  Future<int?> pingServer(String host) async {
    try {
      final result = await platform.invokeMethod('ping', {'host': host});
      return result as int?;
    } catch (e) {
      return null;
    }
  }
}
