import 'package:firebase_auth/firebase_auth.dart';
import 'package:live_chat_app/data/models/chat_user_model.dart';
import 'package:live_chat_app/data/models/message_model.dart';
import 'package:live_chat_app/data/models/user_model.dart';

abstract class DBBase {
  Future<bool> saveUser(UserModel userModel);
  Future<UserModel> readUser(String userID);
  Future<bool> updateUserName(String userID, String userName);
  Future<bool> updatePhotoUrl(String userID, String url);
  Future<List<UserModel>> fetchAllUsers();
  Future<List<ChatUserModel>> fetchChattedUsersIdList(String userID);
  Future<List<UserModel>> getChatedUsers(List<String> chatUserIDList);
  Stream<List<MessageModel>> fetchMessage(
      String currentUserID, String chatUserID);
  Future<bool> saveMessage(MessageModel messageModel);
  Future<DateTime?> getCurrentTime();
}
