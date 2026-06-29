import 'package:shared_preferences/shared_preferences.dart';

import '../models/server_profile.dart';

class StorageService {
  static const _serversKey = 'ns_proxy_servers';
  static const _activeServerKey = 'ns_proxy_active_server';
  static const _proxyOnlyKey = 'ns_proxy_proxy_only';

  Future<List<ServerProfile>> loadServers() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_serversKey);
    if (raw == null || raw.isEmpty) return [];
    return ServerProfile.decodeList(raw);
  }

  Future<void> saveServers(List<ServerProfile> servers) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_serversKey, ServerProfile.encodeList(servers));
  }

  Future<String?> loadActiveServerId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_activeServerKey);
  }

  Future<void> saveActiveServerId(String? id) async {
    final prefs = await SharedPreferences.getInstance();
    if (id == null) {
      await prefs.remove(_activeServerKey);
    } else {
      await prefs.setString(_activeServerKey, id);
    }
  }

  Future<bool> loadProxyOnly() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_proxyOnlyKey) ?? false;
  }

  Future<void> saveProxyOnly(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_proxyOnlyKey, value);
  }
}
