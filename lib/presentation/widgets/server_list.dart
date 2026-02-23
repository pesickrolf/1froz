import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/vpn_provider.dart';
import '../../core/theme/app_theme.dart';

class ServerList extends ConsumerWidget {
  const ServerList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servers = ref.watch(serversProvider);

    if (servers.isEmpty) {
      return Center(
        child: Text(
          'No servers loaded',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey[600],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Text(
            'Available Servers',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: servers.length,
            itemBuilder: (context, index) {
              final server = servers[index];
              return ServerItem(
                server: server,
                onTap: () {
                  ref.read(serversProvider.notifier).selectServer(server.id);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class ServerItem extends StatelessWidget {
  final server;
  final VoidCallback onTap;

  const ServerItem({
    super.key,
    required this.server,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Focus(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: server.isSelected
                    ? AppTheme.primaryBlue.withOpacity(0.2)
                    : AppTheme.cardBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: server.isSelected
                      ? AppTheme.primaryBlue
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: server.qualityColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          server.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          server.country,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (server.ping != null)
                    Text(
                      '${server.ping}ms',
                      style: TextStyle(
                        fontSize: 16,
                        color: server.qualityColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
