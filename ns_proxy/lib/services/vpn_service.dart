import 'package:flutter/foundation.dart';
import 'package:flutter_vless/flutter_vless.dart';

import '../models/server_profile.dart';

class VpnService {
  VpnService({required void Function(VlessStatus status) onStatusChanged})
      : _flutterVless = FlutterVless(onStatusChanged: onStatusChanged);

  final FlutterVless _flutterVless;
  bool _initialized = false;

  static const _connectTimeout = Duration(seconds: 45);
  static const _pingTimeout = Duration(seconds: 20);
  static const _coreVersionTimeout = Duration(seconds: 8);

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
    final profile = refreshProfile(server);

    if (!proxyOnly) {
      final granted = await requestPermission().timeout(
        const Duration(seconds: 30),
        onTimeout: () => false,
      );
      if (!granted) {
        throw Exception('Разрешение VPN не получено');
      }
    }

    await _flutterVless.startVless(
      remark: profile.displayName,
      config: profile.xrayConfig,
      proxyOnly: proxyOnly,
      notificationDisconnectButtonName: 'ОТКЛЮЧИТЬ',
    ).timeout(
      _connectTimeout,
      onTimeout: () => throw Exception('Таймаут запуска VPN'),
    );
  }

  Future<void> disconnect() => _flutterVless.stopVless();

  Future<int> ping(ServerProfile server) async {
    await initialize();
    final profile = refreshProfile(server);
    return _flutterVless.getServerDelay(config: profile.xrayConfig).timeout(
      _pingTimeout,
      onTimeout: () => throw Exception('Таймаут пинга'),
    );
  }

  Future<String?> coreVersion() async {
    try {
      return await _flutterVless
          .getCoreVersion()
          .timeout(_coreVersionTimeout);
    } catch (e) {
      debugPrint('coreVersion error: $e');
      return null;
    }
  }

  static ServerProfile refreshProfile(ServerProfile server) {
    final parsed = parseSingle(server.shareLink);
    if (parsed == null) return server;
    return server.copyWith(
      xrayConfig: parsed.xrayConfig,
      address: parsed.address,
      port: parsed.port,
      security: parsed.security,
      network: parsed.network,
      name: parsed.name.isNotEmpty ? parsed.name : server.name,
    );
  }

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
