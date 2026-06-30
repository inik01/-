import 'package:flutter/foundation.dart';
import 'package:flutter_vless/flutter_vless.dart';

import '../models/server_profile.dart';
import '../services/storage_service.dart';
import '../services/vpn_service.dart';

enum VpnConnectionState { disconnected, connecting, connected, disconnecting }

class VpnProvider extends ChangeNotifier {
  VpnProvider({
    StorageService? storage,
    VpnService? vpnService,
  }) : _storage = storage ?? StorageService() {
    _vpnService = vpnService ?? VpnService(onStatusChanged: _handleStatus);
  }

  late final VpnService _vpnService;
  final StorageService _storage;

  List<ServerProfile> _servers = [];
  ServerProfile? _activeServer;
  VpnConnectionState _connectionState = VpnConnectionState.disconnected;
  VlessStatus? _status;
  bool _proxyOnly = false;
  bool _loading = true;
  String? _error;
  String? _coreVersion;

  List<ServerProfile> get servers => List.unmodifiable(_servers);
  ServerProfile? get activeServer => _activeServer;
  VpnConnectionState get connectionState => _connectionState;
  VlessStatus? get status => _status;
  bool get proxyOnly => _proxyOnly;
  bool get loading => _loading;
  String? get error => _error;
  String? get coreVersion => _coreVersion;

  bool get isConnected => _connectionState == VpnConnectionState.connected;
  bool get isBusy =>
      _connectionState == VpnConnectionState.connecting ||
      _connectionState == VpnConnectionState.disconnecting;

  String get uploadSpeed {
    final speed = _status?.uploadSpeed ?? 0;
    return _formatSpeed(speed);
  }

  String get downloadSpeed {
    final speed = _status?.downloadSpeed ?? 0;
    return _formatSpeed(speed);
  }

  String get duration {
    final seconds = _status?.duration ?? 0;
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  Future<void> initialize() async {
    _loading = true;
    notifyListeners();

    try {
      await _vpnService.initialize();
      _servers = await _storage.loadServers();
      _proxyOnly = await _storage.loadProxyOnly();
      final activeId = await _storage.loadActiveServerId();
      if (activeId != null) {
        _activeServer = _servers.cast<ServerProfile?>().firstWhere(
              (s) => s?.id == activeId,
              orElse: () => _servers.isNotEmpty ? _servers.first : null,
            );
      } else if (_servers.isNotEmpty) {
        _activeServer = _servers.first;
      }
      _coreVersion = await _vpnService.coreVersion();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void _handleStatus(VlessStatus status) {
    _status = status;
    switch (status.connectionState) {
      case VlessConnectionState.connected:
        _connectionState = VpnConnectionState.connected;
      case VlessConnectionState.connecting:
        _connectionState = VpnConnectionState.connecting;
      case VlessConnectionState.disconnecting:
        _connectionState = VpnConnectionState.disconnecting;
      case VlessConnectionState.disconnected:
        _connectionState = VpnConnectionState.disconnected;
      case VlessConnectionState.unknown:
        break;
    }
    notifyListeners();
  }

  Future<void> setActiveServer(ServerProfile server) async {
    _activeServer = server;
    await _storage.saveActiveServerId(server.id);
    notifyListeners();
  }

  Future<List<ServerProfile>> importFromText(String input) async {
    _error = null;
    final imported = VpnService.parseInput(input);
    if (imported.isEmpty) {
      throw Exception('Не найдено VLESS ключей');
    }

    final existingLinks = _servers.map((s) => s.shareLink).toSet();
    final newProfiles =
        imported.where((p) => !existingLinks.contains(p.shareLink)).toList();

    _servers = [..._servers, ...newProfiles];
    if (_activeServer == null && _servers.isNotEmpty) {
      _activeServer = _servers.first;
      await _storage.saveActiveServerId(_activeServer!.id);
    }
    await _storage.saveServers(_servers);
    notifyListeners();
    return newProfiles;
  }

  Future<void> removeServer(ServerProfile server) async {
    _servers = _servers.where((s) => s.id != server.id).toList();
    if (_activeServer?.id == server.id) {
      _activeServer = _servers.isNotEmpty ? _servers.first : null;
      await _storage.saveActiveServerId(_activeServer?.id);
    }
    await _storage.saveServers(_servers);
    notifyListeners();
  }

  Future<void> toggleConnection() async {
    if (isBusy) return;
    if (isConnected) {
      await disconnect();
    } else {
      await connect();
    }
  }

  Future<void> connect() async {
    final server = _activeServer;
    if (server == null) {
      _error = 'Добавьте VLESS ключ';
      notifyListeners();
      return;
    }

    _error = null;
    _connectionState = VpnConnectionState.connecting;
    notifyListeners();

    try {
      await _vpnService.connect(server, proxyOnly: _proxyOnly);
    } catch (e) {
      _error = e.toString();
      _connectionState = VpnConnectionState.disconnected;
      notifyListeners();
    }
  }

  Future<void> disconnect() async {
    _connectionState = VpnConnectionState.disconnecting;
    notifyListeners();
    try {
      await _vpnService.disconnect();
    } catch (e) {
      _error = e.toString();
    }
    _connectionState = VpnConnectionState.disconnected;
    notifyListeners();
  }

  Future<int?> pingServer(ServerProfile server) async {
    try {
      final ms = await _vpnService.ping(server);
      final index = _servers.indexWhere((s) => s.id == server.id);
      if (index >= 0) {
        _servers[index] = server.copyWith(pingMs: ms);
        await _storage.saveServers(_servers);
        if (_activeServer?.id == server.id) {
          _activeServer = _servers[index];
        }
        notifyListeners();
      }
      return ms;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<void> setProxyOnly(bool value) async {
    _proxyOnly = value;
    await _storage.saveProxyOnly(value);
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  String _formatSpeed(num bytesPerSecond) {
    if (bytesPerSecond < 1024) {
      return '${bytesPerSecond.toStringAsFixed(0)} B/s';
    }
    if (bytesPerSecond < 1024 * 1024) {
      return '${(bytesPerSecond / 1024).toStringAsFixed(1)} KB/s';
    }
    return '${(bytesPerSecond / (1024 * 1024)).toStringAsFixed(1)} MB/s';
  }
}
