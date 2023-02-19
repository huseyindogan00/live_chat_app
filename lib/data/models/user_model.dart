import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  String? userID;
  String? email;
  String? userName;
  String? phoneNumber;
  String? photoUrl;
  dynamic createAt;
  String? lastMessageTimeToString;
  int? diffirenceToDays;
  UserModel({
    this.userID,
    this.email,
    this.userName,
    this.phoneNumber,
    this.photoUrl,
    this.createAt,
    this.lastMessageTimeToString,
    this.diffirenceToDays,
  });

  UserModel copyWith({
    String? userID,
    String? email,
    String? userName,
    String? phoneNumber,
    String? photoUrl,
    dynamic? createAt,
    String? lastMessageTimeToString,
    int? diffirenceToDays,
  }) {
    return UserModel(
      userID: userID ?? this.userID,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      createAt: createAt ?? this.createAt,
      lastMessageTimeToString:
          lastMessageTimeToString ?? this.lastMessageTimeToString,
      diffirenceToDays: diffirenceToDays ?? this.diffirenceToDays,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userID': userID,
      'email': email,
      'userName': userName,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'createAt': createAt,
      'lastMessageTimeToString': lastMessageTimeToString,
      'diffirenceToDays': diffirenceToDays,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userID: map['userID'] != null ? map['userID'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      userName: map['userName'] != null ? map['userName'] as String : null,
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
      photoUrl: map['photoUrl'] != null ? map['photoUrl'] as String : null,
      createAt: map['createAt'] as dynamic,
      lastMessageTimeToString: map['lastMessageTimeToString'] != null
          ? map['lastMessageTimeToString'] as String
          : null,
      diffirenceToDays: map['diffirenceToDays'] != null
          ? map['diffirenceToDays'] as int
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(userID: $userID, email: $email, userName: $userName, phoneNumber: $phoneNumber, photoUrl: $photoUrl, createAt: $createAt, lastMessageTimeToString: $lastMessageTimeToString, diffirenceToDays: $diffirenceToDays)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.userID == userID &&
        other.email == email &&
        other.userName == userName &&
        other.phoneNumber == phoneNumber &&
        other.photoUrl == photoUrl &&
        other.createAt == createAt &&
        other.lastMessageTimeToString == lastMessageTimeToString &&
        other.diffirenceToDays == diffirenceToDays;
  }

  @override
  int get hashCode {
    return userID.hashCode ^
        email.hashCode ^
        userName.hashCode ^
        phoneNumber.hashCode ^
        photoUrl.hashCode ^
        createAt.hashCode ^
        lastMessageTimeToString.hashCode ^
        diffirenceToDays.hashCode;
  }
}
