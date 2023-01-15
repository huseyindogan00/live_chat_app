import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  String? userID;
  String? email;
  String? name;
  String? phoneNumber;
  String? photoUrl;
  dynamic createAt;
  UserModel({
    this.userID,
    this.email,
    this.name,
    this.phoneNumber,
    this.photoUrl,
    this.createAt,
  });

  UserModel copyWith({
    String? userID,
    String? email,
    String? name,
    String? phoneNumber,
    String? photoUrl,
    dynamic? createAt,
  }) {
    return UserModel(
      userID: userID ?? this.userID,
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      createAt: createAt ?? this.createAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userID': userID,
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'createAt': createAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userID: map['userID'] != null ? map['userID'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      phoneNumber: map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
      photoUrl: map['photoUrl'] != null ? map['photoUrl'] as String : null,
      createAt: map['createAt'] as dynamic,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(userID: $userID, email: $email, name: $name, phoneNumber: $phoneNumber, photoUrl: $photoUrl, createAt: $createAt)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.userID == userID &&
        other.email == email &&
        other.name == name &&
        other.phoneNumber == phoneNumber &&
        other.photoUrl == photoUrl &&
        other.createAt == createAt;
  }

  @override
  int get hashCode {
    return userID.hashCode ^
        email.hashCode ^
        name.hashCode ^
        phoneNumber.hashCode ^
        photoUrl.hashCode ^
        createAt.hashCode;
  }
}
