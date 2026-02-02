class AddCardRequest {
  final String cardNumber;
  final String cvv;
  final String expiry;
  final bool setAsDefault;

  AddCardRequest({
    required this.cardNumber,
    required this.cvv,
    required this.expiry,
    required this.setAsDefault,
  });

  Map<String, dynamic> toJson() {
    return {
      'cardNumber': cardNumber,
      'cvv': cvv,
      'expiry': expiry,
      'setAsDefault': setAsDefault,
    };
  }
}
