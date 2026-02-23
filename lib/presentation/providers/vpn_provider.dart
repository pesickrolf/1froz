import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/vpn_service.dart';
import '../../data/services/config_parser.dart';
import '../../domain/models/vpn_server.dart';
import '../../domain/models/vpn_status.dart';

final vpnServiceProvider = Provider((ref) => VpnService());
final configParserProvider = Provider((ref) => ConfigParser());

final vpnStatusProvider = StreamProvider<VpnStatus>((ref) {
  final service = ref.watch(vpnServiceProvider);
  return service.statusStream;
});

final serversProvider = StateNotifierProvider<ServersNotifier, List<VpnServer>>((ref) {
  return ServersNotifier(ref);
});

class ServersNotifier extends StateNotifier<List<VpnServer>> {
  final Ref ref;
  
  ServersNotifier(this.ref) : super([]);

  void loadServers(String configUrl) {
    final parser = ref.read(configParserProvider);
    state = parser.parseConfigUrl(configUrl);
    _pingAllServers();
  }

  void selectServer(String serverId) {
    state = [
      for (final server in state)
        server.copyWith(isSelected: server.id == serverId)
    ];
  }

  Future<void> _pingAllServers() async {
    final service = ref.read(vpnServiceProvider);
    for (var i = 0; i < state.length; i++) {
      final server = state[i];
      final ping = await service.pingServer(_extractHost(server.configUrl));
      state = [
        for (var j = 0; j < state.length; j++)
          if (j == i) state[j].copyWith(ping: ping) else state[j]
      ];
    }
  }

  String _extractHost(String url) {
    final uri = Uri.tryParse(url);
    return uri?.host ?? 'unknown';
  }
}

final vpnControllerProvider = StateNotifierProvider<VpnController, VpnControllerState>((ref) {
  return VpnController(ref);
});

class VpnControllerState {
  final VpnStatus status;
  final String? error;

  VpnControllerState({
    this.status = VpnStatus.disconnected,
    this.error,
  });

  VpnControllerState copyWith({VpnStatus? status, String? error}) {
    return VpnControllerState(
      status: status ?? this.status,
      error: error,
    );
  }
}

class VpnController extends StateNotifier<VpnControllerState> {
  final Ref ref;

  VpnController(this.ref) : super(VpnControllerState()) {
    _listenToStatus();
  }

  void _listenToStatus() {
    ref.listen(vpnStatusProvider, (previous, next) {
      next.whenData((status) {
        state = state.copyWith(status: status);
      });
    });
  }

  Future<void> toggleConnection() async {
    if (state.status.isConnected) {
      await disconnect();
    } else {
      await connect();
    }
  }

  Future<void> connect() async {
    final servers = ref.read(serversProvider);
    final selectedServer = servers.firstWhere(
      (s) => s.isSelected,
      orElse: () => servers.isNotEmpty ? servers.first : throw Exception('No servers'),
    );

    state = state.copyWith(status: VpnStatus.connecting);
    final service = ref.read(vpnServiceProvider);
    final success = await service.connect(selectedServer.configUrl);
    
    if (!success) {
      state = state.copyWith(status: VpnStatus.error, error: 'Connection failed');
    }
  }

  Future<void> disconnect() async {
    state = state.copyWith(status: VpnStatus.disconnecting);
    final service = ref.read(vpnServiceProvider);
    await service.disconnect();
  }
}
