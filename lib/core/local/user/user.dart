import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

enum AppUserGender {
  male,
  female,
  unknown;

  String get supabaseValue {
    switch (this) {
      case AppUserGender.male:
        return 'male';
      case AppUserGender.female:
        return 'female';
      case AppUserGender.unknown:
        return 'unknown';
    }
  }

  String get persianTitle {
    switch (this) {
      case AppUserGender.male:
        return 'آقا';
      case AppUserGender.female:
        return 'خانم';
      case AppUserGender.unknown:
        return 'نامشخص';
    }
  }

  static AppUserGender fromSupabaseValue(String? value) {
    switch (value) {
      case 'male':
        return AppUserGender.male;
      case 'female':
        return AppUserGender.female;
      default:
        return AppUserGender.unknown;
    }
  }
}

class AppUser {
  final String id;
  final String email;
  final String? username;
  final AppUserGender gender;
  final int? age;
  final String? accessToken;
  final String? refreshToken;
  final DateTime? createdAt;
  final DateTime? lastSignInAt;
  final bool isEmailVerified;

  const AppUser({
    required this.id,
    required this.email,
    this.username,
    this.gender = AppUserGender.unknown,
    this.age,
    this.accessToken,
    this.refreshToken,
    this.createdAt,
    this.lastSignInAt,
    this.isEmailVerified = false,
  });

  factory AppUser.fromSupabase({
    required supabase.User user,
    supabase.Session? session,
  }) {
    final metadata = user.userMetadata ?? {};

    // پاسخ Supabase Auth اینجا به مدل محلی اپ تبدیل می‌شود تا باقی اپ به SDK وابسته نباشد.
    return AppUser(
      id: user.id,
      email: user.email ?? '',
      username: metadata['username']?.toString(),
      gender: AppUserGender.fromSupabaseValue(metadata['gender']?.toString()),
      age: int.tryParse(metadata['age']?.toString() ?? ''),
      accessToken: session?.accessToken,
      refreshToken: session?.refreshToken,
      createdAt: DateTime.tryParse(user.createdAt),
      lastSignInAt: user.lastSignInAt == null ? null : DateTime.tryParse(user.lastSignInAt!),
      isEmailVerified: user.emailConfirmedAt != null,
    );
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      username: json['username']?.toString(),
      gender: AppUserGender.fromSupabaseValue(json['gender']?.toString()),
      age: int.tryParse(json['age']?.toString() ?? ''),
      accessToken: json['accessToken']?.toString(),
      refreshToken: json['refreshToken']?.toString(),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      lastSignInAt: DateTime.tryParse(json['lastSignInAt']?.toString() ?? ''),
      isEmailVerified: json['isEmailVerified'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'gender': gender.supabaseValue,
      'age': age,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'createdAt': createdAt?.toIso8601String(),
      'lastSignInAt': lastSignInAt?.toIso8601String(),
      'isEmailVerified': isEmailVerified,
    };
  }
}
