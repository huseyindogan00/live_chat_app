import 'package:live_chat_app/data/models/user_model.dart';

abstract class AuthBase {
  Future<UserModel?> currentUser();
  Future<UserModel> signInAnonymously();
  Future<bool> signOut();
  Future<UserModel?> signInWithGmail();
  Future<UserModel?> signInWithFacebook();
  Future<UserModel?> signInWithEmailAndPassword(String email, String password);
  Future<UserModel?> crateUserWithEmailAndPassword(String email, String password);
}
