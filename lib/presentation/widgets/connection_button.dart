import 'package:flutter/material.dart';
import '../../domain/models/vpn_status.dart';
import '../../core/theme/app_theme.dart';

class ConnectionButton extends StatefulWidget {
  final VpnStatus status;
  final VoidCallback onPressed;

  const ConnectionButton({
    super.key,
    required this.status,
    required this.onPressed,
  });

  @override
  State<ConnectionButton> createState() => _ConnectionButtonState();
}

class _ConnectionButtonState extends State<ConnectionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isConnected = widget.status.isConnected;
    final color = isConnected ? AppTheme.successGreen : AppTheme.primaryBlue;

    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: isConnected
                    ? [
                        BoxShadow(
                          color: color.withOpacity(0.6 * _controller.value),
                          blurRadius: 60,
                          spreadRadius: 20,
                        ),
                      ]
                    : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onPressed,
                  customBorder: const CircleBorder(),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          color.withOpacity(0.8),
                          color.withOpacity(0.4),
                        ],
                      ),
                      border: Border.all(
                        color: color,
                        width: 4,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        isConnected ? 'DISCONNECT' : 'CONNECT',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
