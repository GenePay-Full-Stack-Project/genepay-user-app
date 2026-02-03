import 'package:json_annotation/json_annotation.dart';

part 'register_request.g.dart';

@JsonSerializable()
class RegisterRequest {
  final String fullName;
  final String email;
  final String nicNumber;
  final String phoneNumber;
  final String? password;

  RegisterRequest({
    required this.fullName,
    required this.email,
    required this.nicNumber,
    required this.phoneNumber,
    this.password,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}
