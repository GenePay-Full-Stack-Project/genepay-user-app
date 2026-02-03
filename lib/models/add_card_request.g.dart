// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_card_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddCardRequest _$AddCardRequestFromJson(Map<String, dynamic> json) =>
    AddCardRequest(
      cardNumber: json['cardNumber'] as String,
      cvv: json['cvv'] as String,
      expiry: json['expiry'] as String,
      nickname: json['nickname'] as String?,
      setAsDefault: json['setAsDefault'] as bool? ?? false,
    );

Map<String, dynamic> _$AddCardRequestToJson(AddCardRequest instance) =>
    <String, dynamic>{
      'cardNumber': instance.cardNumber,
      'cvv': instance.cvv,
      'expiry': instance.expiry,
      'nickname': instance.nickname,
      'setAsDefault': instance.setAsDefault,
    };
