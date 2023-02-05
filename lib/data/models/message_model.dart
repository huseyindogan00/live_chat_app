// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String userID;
  final String fromWhoID;
  final String whoID;
  bool fromMe;
  final String message;
  final dynamic date;
  MessageModel({
    required this.userID,
    required this.fromWhoID,
    required this.whoID,
    required this.fromMe,
    required this.message,
    this.date,
  });

  MessageModel copyWith({
    String? userID,
    String? fromWhoID,
    String? whoID,
    bool? fromMe,
    String? message,
    dynamic date,
  }) {
    return MessageModel(
      userID: userID ?? this.userID,
      fromWhoID: fromWhoID ?? this.fromWhoID,
      whoID: whoID ?? this.whoID,
      fromMe: fromMe ?? this.fromMe,
      message: message ?? this.message,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userID': userID,
      'fromWhoID': fromWhoID,
      'whoID': whoID,
      'fromMe': fromMe,
      'message': message,
      'date': date ?? FieldValue.serverTimestamp(),
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      userID: map['userID'] as String,
      fromWhoID: map['fromWhoID'] as String,
      whoID: map['whoID'] as String,
      fromMe: map['fromMe'] as bool,
      message: map['message'] as String,
      date: map['date'] as dynamic,
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) => MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MessageModel(userID: $userID, fromWhoID: $fromWhoID, whoID: $whoID, fromMe: $fromMe, message: $message, date: $date)';
  }

  @override
  bool operator ==(covariant MessageModel other) {
    if (identical(this, other)) return true;

    return other.userID == userID &&
        other.fromWhoID == fromWhoID &&
        other.whoID == whoID &&
        other.fromMe == fromMe &&
        other.message == message &&
        other.date == date;
  }

  @override
  int get hashCode {
    return userID.hashCode ^ fromWhoID.hashCode ^ whoID.hashCode ^ fromMe.hashCode ^ message.hashCode ^ date.hashCode;
  }
}
