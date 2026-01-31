class CardModel {
  final String? id;
  final String? cardLast4;
  final String? cardType;
  final String? cardBrand;
  final bool isDefault;

  CardModel({
    this.id,
    this.cardLast4,
    this.cardType,
    this.cardBrand,
    this.isDefault = false,
  });
}
