import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/vpn_provider.dart';
import '../theme/app_colors.dart';

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
      VpnConnectionState.connecting => 'ПОДКЛЮЧЕНИЕ...',
      VpnConnectionState.disconnecting => 'ОТКЛЮЧЕНИЕ...',
      VpnConnectionState.disconnected => 'ПОДКЛЮЧИТЬ',
    };

    return GestureDetector(
      onTap: busy ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: connected
              ? const LinearGradient(
                  colors: [AppColors.greenDeep, AppColors.greenDark],
                )
              : AppColors.buttonGradient,
          boxShadow: AppColors.greenGlow(blur: connected ? 32 : 20, spread: 2),
          border: Border.all(
            color: AppColors.greenLight.withValues(alpha: 0.5),
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
                      size: 40,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.orbitron(
                        color: AppColors.background,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
