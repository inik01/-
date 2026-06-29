import 'package:flutter/foundation.dart';
import 'package:flutter_vless/flutter_vless.dart';

import '../models/server_profile.dart';

class VpnService {
  VpnService({required void Function(VlessStatus status) onStatusChanged})
      : _flutterVless = FlutterVless(onStatusChanged: onStatusChanged);

  final FlutterVless _flutterVless;
  bool _initialized = false;

  FlutterVless get core => _flutterVless;

  Future<void> initialize() async {
    if (_initialized) return;
    await _flutterVless.initializeVless(
      providerBundleIdentifier: 'com.nsproxy.ns_proxy',
      groupIdentifier: 'group.com.nsproxy.ns_proxy',
      notificationIconResourceName: 'ic_launcher',
    );
    _initialized = true;
  }

  Future<bool> requestPermission() => _flutterVless.requestPermission();

  Future<void> connect(ServerProfile server, {bool proxyOnly = false}) async {
    await initialize();
    if (!proxyOnly) {
      final granted = await requestPermission();
      if (!granted) {
        throw Exception('VPN permission denied');
      }
    }
    await _flutterVless.startVless(
      remark: server.displayName,
      config: server.xrayConfig,
      proxyOnly: proxyOnly,
      notificationDisconnectButtonName: 'ОТКЛЮЧИТЬ',
    );
  }

  Future<void> disconnect() => _flutterVless.stopVless();

  Future<int> ping(ServerProfile server) async {
    await initialize();
    return _flutterVless.getServerDelay(config: server.xrayConfig);
  }

  Future<int> pingConnected() => _flutterVless.getConnectedServerDelay();

  Future<String> coreVersion() => _flutterVless.getCoreVersion();

  static List<ServerProfile> parseInput(String input) {
    final profiles = <ServerProfile>[];
    final parsed = FlutterVless.parseMany(input.trim());

    for (final item in parsed) {
      if (!_isVless(item)) continue;
      profiles.add(_fromParsed(item));
    }
    return profiles;
  }

  static ServerProfile? parseSingle(String input) {
    try {
      final item = FlutterVless.parse(input.trim());
      if (!_isVless(item)) return null;
      return _fromParsed(item);
    } catch (e) {
      debugPrint('Parse error: $e');
      return null;
    }
  }

  static bool _isVless(FlutterVlessURL item) {
    return item.url.toLowerCase().startsWith('vless://');
  }

  static ServerProfile _fromParsed(FlutterVlessURL item) {
    final now = DateTime.now();
    return ServerProfile(
      id: '${item.address}:${item.port}:${now.microsecondsSinceEpoch}',
      name: item.remark,
      shareLink: item.url,
      address: item.address,
      port: item.port,
      protocol: 'vless',
      security: _extractSecurity(item.url),
      network: item.network,
      xrayConfig: item.getFullConfiguration(),
      createdAt: now,
    );
  }

  static String _extractSecurity(String url) {
    final uri = Uri.tryParse(url);
    return uri?.queryParameters['security'] ?? 'none';
  }
}
