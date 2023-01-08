import 'package:live_chat_app/models/user_model.dart';
import 'package:live_chat_app/data/interface/auth_base.dart';

class FakeAuthService implements AuthBase {
  String userID = '121121212321321321321312323';
  @override
  UserModel currentUser() {
    return UserModel(userID: userID);
  }

  @override
  Future<UserModel> signInAnonymously() async {
    return await Future.delayed(
      const Duration(seconds: 2),
      () => UserModel(userID: userID),
    );
  }

  @override
  Future<bool> signOut() {
    return Future.value(true);
  }

  @override
  Future<UserModel> signInWithGmail() {
    // TODO: implement signInWithGmail
    throw UnimplementedError();
  }
}