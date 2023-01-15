import 'package:live_chat_app/data/models/user_model.dart';

abstract class DBBase {
  Future<bool> saveUser(UserModel userModel);
}
