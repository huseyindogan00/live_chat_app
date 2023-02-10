import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:live_chat_app/data/models/message_model.dart';
import 'package:live_chat_app/data/models/user_model.dart';
import 'package:live_chat_app/data/services/interface/database_base.dart';

class FirestoreDbService implements DBBase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ///UserModel'i Firebase veritabanına kaydeder.
  @override
  Future<bool> saveUser(UserModel userModel) async {
    userModel.createAt = FieldValue.serverTimestamp();

    await _firestore.collection('users').doc(userModel.userID).set(userModel.toMap());
/* 
    DocumentSnapshot snapshot = await _firestore.doc('users/${userModel.userID}').get();
    Map<String, dynamic> _readUser = snapshot.data() as Map<String, dynamic>;
    UserModel result = UserModel.fromMap(_readUser);   */

    return true;
  }

  /// Verilen userID'ye ait User'ı Firebase'den getirerek UserModel nesnesine dönüştürür ve geriye UserModel döner.
  @override
  Future<UserModel> readUser(String userID) async {
    DocumentSnapshot _readUserSapshot = await _firestore.collection('users').doc(userID).get();

    Map<String, dynamic> _readUserMap = _readUserSapshot.data() as Map<String, dynamic>;

    UserModel userModel = UserModel.fromMap(_readUserMap);

    return userModel;
  }

  @override
  Future<bool> updateUserName(String userID, String newUserName) async {
    QuerySnapshot result = await _firestore.collection('users').where('userName', isEqualTo: newUserName).get();
    if (result.docs.isEmpty) {
      await _firestore.collection('users').doc(userID).update({'userName': newUserName});
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> updatePhotoUrl(String userID, String url) async {
    await _firestore.collection('users').doc(userID).update({'photoUrl': url});
    return true;
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    List<UserModel> userList = [];
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore.collection('users').get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> userMap in querySnapshot.docs) {
      userList.add(UserModel.fromMap(userMap.data()));
    }
    return userList;
  }

  /// Verilen chatUserID ile olan mesajları tarih sırasına göre bir listede döner.
  @override
  Stream<List<MessageModel>> getMessage(String currentUserID, String chatUserID) {
    Stream<QuerySnapshot<Map<String, dynamic>>> snapshot = _firestore
        .collection('users')
        .doc(currentUserID)
        .collection('messages')
        .doc('$currentUserID--$chatUserID')
        .collection('message')
        .orderBy('date', descending: true)
        .snapshots();

    Stream<List<MessageModel>> messageList =
        snapshot.map((mapStreamMessage) => mapStreamMessage.docs.map((e) => MessageModel.fromMap(e.data())).toList());

    return messageList;
  }

  /// Verilen messageModel nesnesini currentUser ve chatUser'a kaydeder.
  @override
  Future<bool> saveMessage(MessageModel messageModel) async {
    await _firestore
        .collection('users')
        .doc(messageModel.fromWhoID)
        .collection('messages')
        .doc('${messageModel.fromWhoID}--${messageModel.whoID}')
        .collection('message')
        .add(messageModel.toMap());

    messageModel.fromMe = false;

    await _firestore
        .collection('users')
        .doc(messageModel.whoID)
        .collection('messages')
        .doc('${messageModel.whoID}--${messageModel.fromWhoID}')
        .collection('message')
        .add(messageModel.toMap());

    return true;
  }
}
