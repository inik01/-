import 'package:flutter/material.dart';

import '../models/server_profile.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class ServerTile extends StatelessWidget {
  const ServerTile({
    super.key,
    required this.server,
    required this.selected,
    required this.onTap,
    this.onDelete,
    this.onPing,
    this.pinging = false,
  });

  final ServerProfile server;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onPing;
  final bool pinging;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.greenPrimary.withValues(alpha: 0.08)
                : AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: selected ? AppColors.greenPrimary : AppColors.cardBorder,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: const Icon(
                  Icons.dns_outlined,
                  color: AppColors.greenPrimary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      server.displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.title().copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${server.address}:${server.port}',
                      style: AppTypography.mono(size: 11),
                    ),
                    Text(
                      '${server.security.toUpperCase()} · ${server.network.toUpperCase()}',
                      style: AppTypography.bodySmall(),
                    ),
                  ],
                ),
              ),
              if (server.pingMs != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    '${server.pingMs} ms',
                    style: AppTypography.statValue(
                      color: _pingColor(server.pingMs!),
                    ),
                  ),
                ),
              if (onPing != null)
                IconButton(
                  onPressed: pinging ? null : onPing,
                  icon: pinging
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.speed, size: 20),
                  color: AppColors.textSecondary,
                  tooltip: 'Пинг',
                ),
              if (onDelete != null)
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, size: 20),
                  color: AppColors.error,
                  tooltip: 'Удалить',
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _pingColor(int ms) {
    if (ms < 100) return AppColors.greenLight;
    if (ms < 300) return AppColors.greenPrimary;
    return AppColors.warning;
  }
}
