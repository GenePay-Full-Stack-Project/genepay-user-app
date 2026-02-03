import 'package:json_annotation/json_annotation.dart';

part 'add_card_request.g.dart';

@JsonSerializable()
class AddCardRequest {
  final String cardNumber;
  final String cvv;
  final String expiry; // MM/YY format
  final String? nickname;
  final bool? setAsDefault;

  AddCardRequest({
    required this.cardNumber,
    required this.cvv,
    required this.expiry,
    this.nickname,
    this.setAsDefault = false,
  });

  factory AddCardRequest.fromJson(Map<String, dynamic> json) =>
      _$AddCardRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AddCardRequestToJson(this);
}
