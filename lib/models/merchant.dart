import 'package:json_annotation/json_annotation.dart';

part 'merchant.g.dart';

@JsonSerializable()
class Merchant {
  final int? id;
  final String? name;
  final String? email;
  final String? businessName;
  final String? businessType;
  final String? phoneNumber;
  final String? stripeAccountId;
  final String? onboardingStatus;
  final double? availableBalance;
  final double? pendingBalance;
  final double? totalEarnings;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? faceId;

  Merchant({
    this.id,
    this.name,
    this.email,
    this.businessName,
    this.businessType,
    this.phoneNumber,
    this.stripeAccountId,
    this.onboardingStatus,
    this.availableBalance,
    this.pendingBalance,
    this.totalEarnings,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.faceId,
  });

  factory Merchant.fromJson(Map<String, dynamic> json) =>
      _$MerchantFromJson(json);
  Map<String, dynamic> toJson() => _$MerchantToJson(this);
}
