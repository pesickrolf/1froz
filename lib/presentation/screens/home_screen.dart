import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/connection_button.dart';
import '../widgets/server_list.dart';
import '../widgets/config_input.dart';
import '../providers/vpn_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpnState = ref.watch(vpnControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              const ConfigInput(),
              const SizedBox(height: 40),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ConnectionButton(
                              status: vpnState.status,
                              onPressed: () => ref.read(vpnControllerProvider.notifier).toggleConnection(),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              vpnState.status.displayText,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (vpnState.error != null) ...[
                              const SizedBox(height: 12),
                              Text(
                                vpnState.error!,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                    const Expanded(
                      flex: 1,
                      child: ServerList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
