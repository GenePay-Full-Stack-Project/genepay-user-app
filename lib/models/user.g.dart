// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  email: json['email'] as String?,
  nicNumber: json['nicNumber'] as String?,
  phoneNumber: json['phoneNumber'] as String?,
  balance: (json['balance'] as num?)?.toDouble(),
  emailVerified: json['emailVerified'] as bool?,
  failedLoginAttempts: (json['failedLoginAttempts'] as num?)?.toInt(),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  faceId: json['faceId'] as String?,
  faceEnrolled: json['faceEnrolled'] as bool?,
  cardLinked: json['cardLinked'] as bool?,
  emailVerificationCode: json['emailVerificationCode'] as String?,
  emailVerificationExpiry: json['emailVerificationExpiry'] == null
      ? null
      : DateTime.parse(json['emailVerificationExpiry'] as String),
  lockedUntil: json['lockedUntil'] == null
      ? null
      : DateTime.parse(json['lockedUntil'] as String),
  lastLoginAt: json['lastLoginAt'] == null
      ? null
      : DateTime.parse(json['lastLoginAt'] as String),
  status: $enumDecodeNullable(_$UserStatusEnumMap, json['status']),
  cards: (json['cards'] as List<dynamic>?)
      ?.map((e) => CardModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'nicNumber': instance.nicNumber,
  'phoneNumber': instance.phoneNumber,
  'balance': instance.balance,
  'emailVerified': instance.emailVerified,
  'status': _$UserStatusEnumMap[instance.status],
  'failedLoginAttempts': instance.failedLoginAttempts,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'faceId': instance.faceId,
  'faceEnrolled': instance.faceEnrolled,
  'cardLinked': instance.cardLinked,
  'emailVerificationCode': instance.emailVerificationCode,
  'emailVerificationExpiry': instance.emailVerificationExpiry
      ?.toIso8601String(),
  'lockedUntil': instance.lockedUntil?.toIso8601String(),
  'lastLoginAt': instance.lastLoginAt?.toIso8601String(),
  'cards': instance.cards,
};

const _$UserStatusEnumMap = {
  UserStatus.active: 'ACTIVE',
  UserStatus.suspended: 'SUSPENDED',
  UserStatus.inactive: 'INACTIVE',
  UserStatus.deleted: 'DELETED',
};
