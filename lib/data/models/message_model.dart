import 'dart:convert';

class MessageModel {
  final String userID;
  final String fromWho;
  final String who;
  final bool fromMe;
  final String message;
  final dynamic date;
  MessageModel({
    required this.userID,
    required this.fromWho,
    required this.who,
    required this.fromMe,
    required this.message,
    required this.date,
  });

  MessageModel copyWith({
    String? userID,
    String? fromWho,
    String? who,
    bool? fromMe,
    String? message,
    dynamic? date,
  }) {
    return MessageModel(
      userID: userID ?? this.userID,
      fromWho: fromWho ?? this.fromWho,
      who: who ?? this.who,
      fromMe: fromMe ?? this.fromMe,
      message: message ?? this.message,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userID': userID,
      'fromWho': fromWho,
      'who': who,
      'fromMe': fromMe,
      'message': message,
      'date': date,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      userID: map['userID'] as String,
      fromWho: map['fromWho'] as String,
      who: map['who'] as String,
      fromMe: map['fromMe'] as bool,
      message: map['message'] as String,
      date: map['date'] as dynamic,
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) => MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MessageModel(userID: $userID, fromWho: $fromWho, who: $who, fromMe: $fromMe, message: $message, date: $date)';
  }

  @override
  bool operator ==(covariant MessageModel other) {
    if (identical(this, other)) return true;

    return other.userID == userID &&
        other.fromWho == fromWho &&
        other.who == who &&
        other.fromMe == fromMe &&
        other.message == message &&
        other.date == date;
  }

  @override
  int get hashCode {
    return userID.hashCode ^ fromWho.hashCode ^ who.hashCode ^ fromMe.hashCode ^ message.hashCode ^ date.hashCode;
  }
}
