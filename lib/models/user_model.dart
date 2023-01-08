// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  final String? userID;
  final String? gmail;
  final String? name;
  final String? phoneNumber;
  final String? photoUrl;

  UserModel({
    this.userID,
    this.gmail,
    this.name,
    this.phoneNumber,
    this.photoUrl,
  });

  @override
  String toString() {
    // TODO: implement toString
    return 'userId: $userID\ngmail: $gmail\nname: $name\nphoneNumber: $phoneNumber\nphotoUrl: $photoUrl';
  }
}
