import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/vpn_provider.dart';
import '../../core/theme/app_theme.dart';

class ConfigInput extends ConsumerStatefulWidget {
  const ConfigInput({super.key});

  @override
  ConsumerState<ConfigInput> createState() => _ConfigInputState();
}

class _ConfigInputState extends ConsumerState<ConfigInput> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _loadServers() {
    final url = _controller.text.trim();
    if (url.isNotEmpty) {
      ref.read(serversProvider.notifier).loadServers(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Focus(
            focusNode: _focusNode,
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Paste VPN config URL here...',
                filled: true,
                fillColor: AppTheme.cardBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppTheme.primaryBlue,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
              ),
              style: const TextStyle(fontSize: 18),
              onSubmitted: (_) => _loadServers(),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Focus(
          child: ElevatedButton(
            onPressed: _loadServers,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 20,
              ),
              backgroundColor: AppTheme.primaryBlue,
            ),
            child: const Text(
              'Load Servers',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
