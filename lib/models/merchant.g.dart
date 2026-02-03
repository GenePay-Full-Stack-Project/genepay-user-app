// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Merchant _$MerchantFromJson(Map<String, dynamic> json) => Merchant(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  email: json['email'] as String?,
  businessName: json['businessName'] as String?,
  businessType: json['businessType'] as String?,
  phoneNumber: json['phoneNumber'] as String?,
  stripeAccountId: json['stripeAccountId'] as String?,
  onboardingStatus: json['onboardingStatus'] as String?,
  availableBalance: (json['availableBalance'] as num?)?.toDouble(),
  pendingBalance: (json['pendingBalance'] as num?)?.toDouble(),
  totalEarnings: (json['totalEarnings'] as num?)?.toDouble(),
  isActive: json['isActive'] as bool?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  faceId: json['faceId'] as String?,
);

Map<String, dynamic> _$MerchantToJson(Merchant instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'businessName': instance.businessName,
  'businessType': instance.businessType,
  'phoneNumber': instance.phoneNumber,
  'stripeAccountId': instance.stripeAccountId,
  'onboardingStatus': instance.onboardingStatus,
  'availableBalance': instance.availableBalance,
  'pendingBalance': instance.pendingBalance,
  'totalEarnings': instance.totalEarnings,
  'isActive': instance.isActive,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'faceId': instance.faceId,
};
