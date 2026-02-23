import 'package:flutter/material.dart';

class VpnServer {
  final String id;
  final String name;
  final String country;
  final String configUrl;
  final int? ping;
  final bool isSelected;

  VpnServer({
    required this.id,
    required this.name,
    required this.country,
    required this.configUrl,
    this.ping,
    this.isSelected = false,
  });

  VpnServer copyWith({
    String? id,
    String? name,
    String? country,
    String? configUrl,
    int? ping,
    bool? isSelected,
  }) {
    return VpnServer(
      id: id ?? this.id,
      name: name ?? this.name,
      country: country ?? this.country,
      configUrl: configUrl ?? this.configUrl,
      ping: ping ?? this.ping,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  String get quality {
    if (ping == null) return 'Unknown';
    if (ping! < 50) return 'Excellent';
    if (ping! < 100) return 'Good';
    if (ping! < 200) return 'Fair';
    return 'Poor';
  }

  Color get qualityColor {
    if (ping == null) return Colors.grey;
    if (ping! < 50) return Colors.green;
    if (ping! < 100) return Colors.lightGreen;
    if (ping! < 200) return Colors.orange;
    return Colors.red;
  }
}
