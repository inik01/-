import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/vpn_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/connect_button.dart';
import '../widgets/glow_container.dart';
import '../widgets/ns_logo.dart';
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
              label: const Text('Добавить'),
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
          return const Center(
            child: CircularProgressIndicator(color: AppColors.greenPrimary),
          );
        }

        final server = vpn.activeServer;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 24),
                Text(
                  'NS PROXY',
                  style: GoogleFonts.orbitron(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.greenPrimary,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 32),
                const NsLogo(size: 100),
                const SizedBox(height: 40),
                ConnectButton(
                  state: vpn.connectionState,
                  busy: vpn.isBusy,
                  onPressed: server == null ? null : () => vpn.toggleConnection(),
                ),
                const SizedBox(height: 32),
                if (server != null) ...[
                  GlowContainer(
                    active: vpn.isConnected,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.circle,
                              size: 10,
                              color: AppColors.greenPrimary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                server.displayName,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${server.address}:${server.port}',
                            style: GoogleFonts.inter(
                              color: AppColors.textMuted,
                              fontSize: 12,
                            ),
                          ),
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
                        Text(
                          'Добавьте VLESS ключ',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Импортируйте ключ или подписку на вкладке «Серверы»',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: AppColors.textMuted,
                            fontSize: 13,
                          ),
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
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
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      vpn.error!,
                      style: GoogleFonts.inter(
                        color: AppColors.error,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                Text(
                  vpn.coreVersion != null
                      ? 'Xray ${vpn.coreVersion}'
                      : 'NS Proxy v1.0.0',
                  style: GoogleFonts.inter(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
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
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.greenPrimary, size: 18),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              color: AppColors.textMuted,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.orbitron(
              color: AppColors.textPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
