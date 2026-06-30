import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/vpn_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/server_tile.dart';
import 'import_screen.dart';

class ServersScreen extends StatefulWidget {
  const ServersScreen({super.key});

  @override
  State<ServersScreen> createState() => _ServersScreenState();
}

class _ServersScreenState extends State<ServersScreen> {
  String? _pingingId;

  @override
  Widget build(BuildContext context) {
    return Consumer<VpnProvider>(
      builder: (context, vpn, _) {
        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Text(
                  'Серверы',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '${vpn.servers.length} VLESS профилей',
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: vpn.servers.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.cloud_off_outlined,
                              size: 48,
                              color: AppColors.textMuted,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Нет серверов',
                              style: TextStyle(color: AppColors.textMuted),
                            ),
                            const SizedBox(height: 16),
                            OutlinedButton.icon(
                              onPressed: () => _openImport(context),
                              icon: const Icon(Icons.add),
                              label: const Text('Импорт VLESS'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.greenPrimary,
                                side: const BorderSide(
                                  color: AppColors.greenPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: vpn.servers.length,
                        itemBuilder: (context, index) {
                          final server = vpn.servers[index];
                          return ServerTile(
                            server: server,
                            selected: vpn.activeServer?.id == server.id,
                            pinging: _pingingId == server.id,
                            onTap: () => vpn.setActiveServer(server),
                            onPing: () => _ping(context, vpn, server.id),
                            onDelete: () => _confirmDelete(context, vpn, server),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _ping(
    BuildContext context,
    VpnProvider vpn,
    String serverId,
  ) async {
    final server = vpn.servers.firstWhere((s) => s.id == serverId);
    setState(() => _pingingId = serverId);
    final ms = await vpn.pingServer(server);
    setState(() => _pingingId = null);
    if (context.mounted && ms != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Пинг: $ms ms')),
      );
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    VpnProvider vpn,
    dynamic server,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить сервер?'),
        content: Text('Удалить «${server.displayName}»?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await vpn.removeServer(server);
    }
  }

  void _openImport(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ImportScreen()),
    );
  }
}
