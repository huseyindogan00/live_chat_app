import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:live_chat_app/data/models/user_model.dart';
import 'package:live_chat_app/data/services/interface/database_base.dart';

class FirestoreDbService implements DBBase {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Future<bool> saveUser(UserModel userModel) async {
    userModel.createAt = FieldValue.serverTimestamp();
    await firestore.collection('users').doc(userModel.userID).set(userModel.toMap());

    return true;
  }
}
