import 'package:flutter/material.dart';

import '../providers/vpn_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class ConnectButton extends StatelessWidget {
  const ConnectButton({
    super.key,
    required this.state,
    required this.onPressed,
    this.busy = false,
  });

  final VpnConnectionState state;
  final VoidCallback? onPressed;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final connected = state == VpnConnectionState.connected;
    final label = switch (state) {
      VpnConnectionState.connected => 'ОТКЛЮЧИТЬ',
      VpnConnectionState.connecting => 'ПОДКЛЮЧЕНИЕ',
      VpnConnectionState.disconnecting => 'ОТКЛЮЧЕНИЕ',
      VpnConnectionState.disconnected => 'ПОДКЛЮЧИТЬ',
    };

    return GestureDetector(
      onTap: busy ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 176,
        height: 176,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: connected
              ? const LinearGradient(
                  colors: [AppColors.greenDeep, AppColors.greenDark],
                )
              : AppColors.buttonGradient,
          boxShadow: AppColors.greenGlow(blur: connected ? 28 : 18, spread: 1),
          border: Border.all(
            color: AppColors.greenLight.withValues(alpha: 0.45),
            width: 2,
          ),
        ),
        child: Center(
          child: busy
              ? const SizedBox(
                  width: 36,
                  height: 36,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: AppColors.background,
                  ),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      connected ? Icons.power_settings_new : Icons.shield_outlined,
                      color: AppColors.background,
                      size: 38,
                    ),
                    const SizedBox(height: 10),
                    Text(label, textAlign: TextAlign.center, style: AppTypography.button()),
                  ],
                ),
        ),
      ),
    );
  }
}
