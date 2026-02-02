class User {
  final String? id;
  final String? name;
  final String? email;
  final String? nicNumber;
  final String? phoneNumber;
  final bool faceEnrolled;

  User({
    this.id,
    this.name,
    this.email,
    this.nicNumber,
    this.phoneNumber,
    this.faceEnrolled = false,
  });
}
