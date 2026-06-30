import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/vpn_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/connect_button.dart';
import '../widgets/glow_container.dart';
import 'import_screen.dart';
import 'servers_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _tabIndex,
        children: const [
          _ConnectTab(),
          ServersScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        onDestinationSelected: (index) => setState(() => _tabIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.shield_outlined),
            selectedIcon: Icon(Icons.shield),
            label: 'Главная',
          ),
          NavigationDestination(
            icon: Icon(Icons.dns_outlined),
            selectedIcon: Icon(Icons.dns),
            label: 'Серверы',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Настройки',
          ),
        ],
      ),
      floatingActionButton: _tabIndex == 1
          ? FloatingActionButton.extended(
              onPressed: () => _openImport(context),
              icon: const Icon(Icons.add),
              label: Text('Добавить', style: AppTypography.body(size: 13)),
            )
          : null,
    );
  }

  void _openImport(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ImportScreen()),
    );
  }
}

class _ConnectTab extends StatelessWidget {
  const _ConnectTab();

  @override
  Widget build(BuildContext context) {
    return Consumer<VpnProvider>(
      builder: (context, vpn, _) {
        if (vpn.loading) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: AppColors.greenPrimary),
                const SizedBox(height: 16),
                Text('Загрузка...', style: AppTypography.bodySmall()),
              ],
            ),
          );
        }

        final server = vpn.activeServer;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 32),
                Text('NS PROXY', style: AppTypography.displayLarge()),
                const SizedBox(height: 8),
                Text(
                  'VLESS VPN',
                  style: AppTypography.label(color: AppColors.textMuted)
                      .copyWith(letterSpacing: 2.5),
                ),
                const Spacer(),
                ConnectButton(
                  state: vpn.connectionState,
                  busy: vpn.isBusy,
                  onPressed: server == null ? null : () => vpn.toggleConnection(),
                ),
                const Spacer(),
                if (server != null) ...[
                  GlowContainer(
                    active: vpn.isConnected,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(server.displayName, style: AppTypography.title()),
                        const SizedBox(height: 6),
                        Text(
                          '${server.address}:${server.port}',
                          style: AppTypography.mono(),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${server.security.toUpperCase()} · ${server.network.toUpperCase()}',
                          style: AppTypography.bodySmall(),
                        ),
                      ],
                    ),
                  ),
                  if (vpn.isConnected) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            icon: Icons.timer_outlined,
                            label: 'Время',
                            value: vpn.duration,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            icon: Icons.arrow_downward,
                            label: 'Загрузка',
                            value: vpn.downloadSpeed,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            icon: Icons.arrow_upward,
                            label: 'Отдача',
                            value: vpn.uploadSpeed,
                          ),
                        ),
                      ],
                    ),
                  ],
                ] else ...[
                  GlowContainer(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.vpn_key_outlined,
                          color: AppColors.greenPrimary,
                          size: 32,
                        ),
                        const SizedBox(height: 12),
                        Text('Добавьте VLESS ключ', style: AppTypography.title()),
                        const SizedBox(height: 8),
                        Text(
                          'Импортируйте ключ или ссылку на подписку',
                          textAlign: TextAlign.center,
                          style: AppTypography.bodySmall(),
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const ImportScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Импортировать'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.greenPrimary,
                            side: const BorderSide(color: AppColors.greenPrimary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (vpn.error != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      vpn.error!,
                      style: AppTypography.bodySmall(color: AppColors.error),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                Text(
                  vpn.coreVersion != null
                      ? 'Xray ${vpn.coreVersion}'
                      : 'NS Proxy v1.0.4',
                  style: AppTypography.mono(size: 10),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.greenPrimary, size: 18),
          const SizedBox(height: 4),
          Text(label, style: AppTypography.label(color: AppColors.textMuted)),
          const SizedBox(height: 2),
          Text(value, style: AppTypography.statValue()),
        ],
      ),
    );
  }
}
