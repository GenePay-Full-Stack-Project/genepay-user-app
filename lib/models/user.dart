import 'package:json_annotation/json_annotation.dart';
import 'card_model.dart';

part 'user.g.dart';

enum UserStatus {
  @JsonValue('ACTIVE')
  active,
  @JsonValue('SUSPENDED')
  suspended,
  @JsonValue('INACTIVE')
  inactive,
  @JsonValue('DELETED')
  deleted,
}

@JsonSerializable()
class User {
  final int? id;
  final String? name;
  final String? email;
  final String? nicNumber;
  final String? phoneNumber;
  final double? balance;
  final bool? emailVerified;
  final UserStatus? status;
  final int? failedLoginAttempts;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? faceId;
  final bool? faceEnrolled;
  final bool? cardLinked;
  final String? emailVerificationCode;
  final DateTime? emailVerificationExpiry;
  final DateTime? lockedUntil;
  final DateTime? lastLoginAt;
  final List<CardModel>? cards;

  User({
    this.id,
    this.name,
    this.email,
    this.nicNumber,
    this.phoneNumber,
    this.balance,
    this.emailVerified,
    this.failedLoginAttempts,
    this.createdAt,
    this.updatedAt,
    this.faceId,
    this.faceEnrolled,
    this.cardLinked,
    this.emailVerificationCode,
    this.emailVerificationExpiry,
    this.lockedUntil,
    this.lastLoginAt,
    this.status,
    this.cards,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // Normalize backend field names: some services return `fullName` while
    // others use `name`. Ensure `name` is populated for the client model.
    final normalized = Map<String, dynamic>.from(json);
    if (normalized['name'] == null && normalized['fullName'] != null) {
      normalized['name'] = normalized['fullName'];
    }

    // Also handle possible camelCase vs snake_case mismatches
    if (normalized['nicNumber'] == null && normalized['nic_number'] != null) {
      normalized['nicNumber'] = normalized['nic_number'];
    }

    // Map backend boolean flag for face enrollment
    if (normalized['faceEnrolled'] == null &&
        normalized['face_enrolled'] != null) {
      normalized['faceEnrolled'] = normalized['face_enrolled'];
    }

    // Map balance which may come as string or number
    if (normalized['balance'] is String) {
      try {
        normalized['balance'] = double.parse(normalized['balance']);
      } catch (_) {}
    }

    // Map email verification fields from snake_case
    if (normalized['emailVerificationExpiry'] == null &&
        normalized['email_verification_expiry'] != null) {
      normalized['emailVerificationExpiry'] =
          normalized['email_verification_expiry'];
    }

    // Map lockedUntil/lastLoginAt
    if (normalized['lockedUntil'] == null &&
        normalized['locked_until'] != null) {
      normalized['lockedUntil'] = normalized['locked_until'];
    }
    if (normalized['lastLoginAt'] == null &&
        normalized['last_login_at'] != null) {
      normalized['lastLoginAt'] = normalized['last_login_at'];
    }

    // Map cards list from backend
    if (normalized['cards'] is List) {
      normalized['cards'] = (normalized['cards'] as List).map((e) {
        return e is Map<String, dynamic> ? CardModel.fromJson(e) : e;
      }).toList();
    }

    return _$UserFromJson(normalized);
  }

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
