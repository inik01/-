import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/vpn_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/ns_logo.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<VpnProvider>(
      builder: (context, vpn, _) {
        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Center(child: NsLogo(size: 72, showGlow: false)),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'NS Proxy',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.greenPrimary,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                      ),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  'VLESS VPN клиент',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                ),
              ),
              const SizedBox(height: 32),
              _SectionTitle('Подключение'),
              SwitchListTile(
                title: const Text('Только прокси'),
                subtitle: const Text(
                  'Без VPN-туннеля (локальный SOCKS/HTTP прокси)',
                  style: TextStyle(fontSize: 12),
                ),
                value: vpn.proxyOnly,
                onChanged: vpn.isConnected
                    ? null
                    : (value) => vpn.setProxyOnly(value),
              ),
              const SizedBox(height: 16),
              _SectionTitle('О приложении'),
              _InfoTile(
                icon: Icons.info_outline,
                title: 'Версия',
                value: '1.0.0',
              ),
              if (vpn.coreVersion != null)
                _InfoTile(
                  icon: Icons.memory,
                  title: 'Xray Core',
                  value: vpn.coreVersion!,
                ),
              _InfoTile(
                icon: Icons.devices,
                title: 'Платформа',
                value: _platformName(),
              ),
              _InfoTile(
                icon: Icons.security,
                title: 'Протокол',
                value: 'VLESS',
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: const Text(
                  'NS Proxy читает VLESS ключи и подписки, как Hiddify. '
                  'Поддерживаются Reality, XTLS, WebSocket, gRPC, TCP и другие транспорты Xray.',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _platformName() {
    if (Platform.isAndroid) return 'Android';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isLinux) return 'Linux';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isIOS) return 'iOS';
    return 'Unknown';
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: AppColors.greenPrimary,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.textSecondary, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      trailing: Text(
        value,
        style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
      ),
    );
  }
}
