import 'dart:convert';

class SyncPackage {
  final String version;
  final String type; // 'debt_request' | 'debt_response'
  final String senderPublicKey;
  final String recipientPublicKey;
  final DateTime expiresAt;
  final String encryptedPayload; // base64

  const SyncPackage({
    required this.version,
    required this.type,
    required this.senderPublicKey,
    required this.recipientPublicKey,
    required this.expiresAt,
    required this.encryptedPayload,
  });

  Map<String, dynamic> toJson() => {
        'version': version,
        'type': type,
        'sender_pk': senderPublicKey,
        'recipient_pk': recipientPublicKey,
        'expires_at': expiresAt.toIso8601String(),
        'payload': encryptedPayload,
      };

  factory SyncPackage.fromJson(Map<String, dynamic> json) => SyncPackage(
        version: json['version'] as String,
        type: json['type'] as String,
        senderPublicKey: json['sender_pk'] as String,
        recipientPublicKey: json['recipient_pk'] as String,
        expiresAt: DateTime.parse(json['expires_at'] as String),
        encryptedPayload: json['payload'] as String,
      );

  int get estimatedBytes => jsonEncode(toJson()).length;
}
