// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ChatUserModel {
  String chatUserId;
  ChatUserModel({
    required this.chatUserId,
  });

  ChatUserModel copyWith({
    String? chatUserId,
  }) {
    return ChatUserModel(
      chatUserId: chatUserId ?? this.chatUserId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chatUserId': chatUserId,
    };
  }

  factory ChatUserModel.fromMap(Map<String, dynamic> map) {
    return ChatUserModel(
      chatUserId: map['chatUserId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatUserModel.fromJson(String source) => ChatUserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ChatUserModel(chatUserId: $chatUserId)';

  @override
  bool operator ==(covariant ChatUserModel other) {
    if (identical(this, other)) return true;

    return other.chatUserId == chatUserId;
  }

  @override
  int get hashCode => chatUserId.hashCode;
}
