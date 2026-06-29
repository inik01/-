import 'dart:convert';

/// Saved VPN server profile parsed from a VLESS share link or subscription.
class ServerProfile {
  const ServerProfile({
    required this.id,
    required this.name,
    required this.shareLink,
    required this.address,
    required this.port,
    required this.protocol,
    required this.security,
    required this.network,
    required this.xrayConfig,
    this.pingMs,
    this.createdAt,
  });

  final String id;
  final String name;
  final String shareLink;
  final String address;
  final int port;
  final String protocol;
  final String security;
  final String network;
  final String xrayConfig;
  final int? pingMs;
  final DateTime? createdAt;

  String get displayName => name.isNotEmpty ? name : '$address:$port';

  ServerProfile copyWith({
    String? id,
    String? name,
    String? shareLink,
    String? address,
    int? port,
    String? protocol,
    String? security,
    String? network,
    String? xrayConfig,
    int? pingMs,
    DateTime? createdAt,
  }) {
    return ServerProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      shareLink: shareLink ?? this.shareLink,
      address: address ?? this.address,
      port: port ?? this.port,
      protocol: protocol ?? this.protocol,
      security: security ?? this.security,
      network: network ?? this.network,
      xrayConfig: xrayConfig ?? this.xrayConfig,
      pingMs: pingMs ?? this.pingMs,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'shareLink': shareLink,
        'address': address,
        'port': port,
        'protocol': protocol,
        'security': security,
        'network': network,
        'xrayConfig': xrayConfig,
        'pingMs': pingMs,
        'createdAt': createdAt?.toIso8601String(),
      };

  factory ServerProfile.fromJson(Map<String, dynamic> json) {
    return ServerProfile(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      shareLink: json['shareLink'] as String,
      address: json['address'] as String,
      port: json['port'] as int,
      protocol: json['protocol'] as String? ?? 'vless',
      security: json['security'] as String? ?? '',
      network: json['network'] as String? ?? 'tcp',
      xrayConfig: json['xrayConfig'] as String,
      pingMs: json['pingMs'] as int?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  static String encodeList(List<ServerProfile> profiles) {
    return jsonEncode(profiles.map((p) => p.toJson()).toList());
  }

  static List<ServerProfile> decodeList(String raw) {
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((item) => ServerProfile.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
