import 'package:live_chat_app/models/user_model.dart';

abstract class AuthBase {
  UserModel? currentUser();
  Future<UserModel> signInAnonymously();
  Future<bool> signOut();
  Future<UserModel?> signInWithGmail();
}
