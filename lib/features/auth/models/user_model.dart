import 'dart:convert';

class UserModel {
  final String id;
  final String displayName;
  final String email;
  final String? avatarUrl;
  final List<String> providers;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.displayName,
    required this.email,
    this.avatarUrl,
    required this.providers,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      displayName: json['displayName'] as String? ?? json['display_name'] as String? ?? '',
      email: json['email'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      providers: (json['providers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              (json['createdAt'] as int) * 1000)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'displayName': displayName,
        'email': email,
        'avatarUrl': avatarUrl,
        'providers': providers,
        'createdAt': createdAt.millisecondsSinceEpoch ~/ 1000,
      };

  String get maskedEmail {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final name = parts[0];
    final domain = parts[1];
    if (name.length <= 2) return email;
    return '${name[0]}***${name[name.length - 1]}@$domain';
  }

  static String maskEmailStatic(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final name = parts[0];
    final domain = parts[1];
    if (name.length <= 2) return email;
    return '${name[0]}***${name[name.length - 1]}@$domain';
  }

  UserModel copyWith({
    String? id,
    String? displayName,
    String? email,
    String? avatarUrl,
    List<String>? providers,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      providers: providers ?? this.providers,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static UserModel fromJsonString(String jsonStr) =>
      UserModel.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);

  String toJsonString() => jsonEncode(toJson());
}
