import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/vpn_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

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
              const SizedBox(height: 8),
              Center(child: Text('NS PROXY', style: AppTypography.displayLarge())),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  'VLESS VPN клиент',
                  style: AppTypography.bodySmall(),
                ),
              ),
              const SizedBox(height: 32),
              _SectionTitle('Подключение'),
              SwitchListTile(
                title: Text('Только прокси', style: AppTypography.body()),
                subtitle: Text(
                  'Локальный SOCKS/HTTP без VPN-туннеля',
                  style: AppTypography.bodySmall(),
                ),
                value: vpn.proxyOnly,
                onChanged: vpn.isConnected
                    ? null
                    : (value) => vpn.setProxyOnly(value),
              ),
              const SizedBox(height: 16),
              _SectionTitle('О приложении'),
              _InfoTile(icon: Icons.info_outline, title: 'Версия', value: '1.0.4'),
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
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Text(
                  'Поддерживаются VLESS ключи, base64-подписки и ссылки http(s). '
                  'Reality, XTLS, WebSocket, gRPC, TCP и другие транспорты Xray.',
                  style: AppTypography.bodySmall().copyWith(height: 1.55),
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
      child: Text(title.toUpperCase(), style: AppTypography.label()),
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
      title: Text(title, style: AppTypography.body()),
      trailing: Text(value, style: AppTypography.mono(size: 11)),
    );
  }
}
