import 'dart:convert';
import 'dart:ffi';

import 'package:timeago/timeago.dart' as timeago;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:live_chat_app/data/models/chat_user_model.dart';
import 'package:live_chat_app/data/models/message_model.dart';
import 'package:live_chat_app/data/models/time_model.dart';
import 'package:live_chat_app/data/models/user_model.dart';
import 'package:live_chat_app/data/services/interface/database_base.dart';

class FirestoreDbService implements DBBase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ///UserModel'i Firebase veritabanına kaydeder.
  @override
  Future<bool> saveUser(UserModel userModel) async {
    userModel.createAt = FieldValue.serverTimestamp();

    await _firestore
        .collection('users')
        .doc(userModel.userID)
        .set(userModel.toMap());
/* 
    DocumentSnapshot snapshot = await _firestore.doc('users/${userModel.userID}').get();
    Map<String, dynamic> _readUser = snapshot.data() as Map<String, dynamic>;
    UserModel result = UserModel.fromMap(_readUser);   */

    return true;
  }

  /// Verilen userID'ye ait User'ı Firebase'den getirerek UserModel nesnesine dönüştürür ve geriye UserModel döner.
  @override
  Future<UserModel> readUser(String userID) async {
    DocumentSnapshot _readUserSapshot =
        await _firestore.collection('users').doc(userID).get();

    Map<String, dynamic> _readUserMap =
        _readUserSapshot.data() as Map<String, dynamic>;

    UserModel userModel = UserModel.fromMap(_readUserMap);

    return userModel;
  }

  @override
  Future<bool> updateUserName(String userID, String newUserName) async {
    QuerySnapshot result = await _firestore
        .collection('users')
        .where('userName', isEqualTo: newUserName)
        .get();
    if (result.docs.isEmpty) {
      await _firestore
          .collection('users')
          .doc(userID)
          .update({'userName': newUserName});
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
  Future<List<UserModel>> fetchAllUsers() async {
    List<UserModel> userList = [];

    QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('users')
        .orderBy('createAt', descending: true)
        .get();

    for (var userMap in snapshot.docs) {
      userList.add(UserModel.fromMap(userMap.data()));
    }

    return userList;
  }

  /// Verilen ID ye ait USER ın konuştuğu kişilere ait ID leri bir ChatUserModel ile döndürür.
  @override
  Future<List<ChatUserModel>> fetchChattedUsersIdList(String userID) async {
    List<ChatUserModel> chatUserList = [];
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection('users')
        .doc(userID)
        .collection('chatUsers')
        .get();

    for (var chatUser in querySnapshot.docs) {
      chatUserList.add(ChatUserModel.fromMap(chatUser.data()));
    }
    return chatUserList;
  }

  // Verilen userId listesinde bulunan USER ları geriye döndürür.
  @override
  Future<List<UserModel>> getChatedUsers(List<String> chatUserIDList) async {
    List<UserModel> userList = [];
    for (var i = 0; i < chatUserIDList.length; i++) {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('users').doc(chatUserIDList[i]).get();

      userList.add(UserModel.fromMap(snapshot.data()!));
    }
    return userList;
  }

  /// Verilen chatUserID ile olan mesajları tarih sırasına göre bir listede döner.
  @override
  Stream<List<MessageModel>> fetchMessage(
      String currentUserID, String chatUserID) {
    Stream<QuerySnapshot<Map<String, dynamic>>> snapshot = _firestore
        .collection('users')
        .doc(currentUserID)
        .collection('messages')
        .doc('$currentUserID--$chatUserID')
        .collection('message')
        .orderBy('date', descending: true)
        .snapshots();

    Stream<List<MessageModel>> messageList = snapshot.map((mapStreamMessage) =>
        mapStreamMessage.docs
            .map((dataMap) => MessageModel.fromMap(dataMap.data()))
            .toList());

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

    //Kaydedilen mesaja ait kimeId si kullanıcının chatUsers collectionuna yazılıyor
    await _firestore
        .collection('users')
        .doc(messageModel.fromWhoID)
        .collection('chatUsers')
        .doc(messageModel.whoID)
        .set({'chatUserId': messageModel.whoID});

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

  /// atılan son mesajın üzerinden geçen zamanı String olarak geriye döndürür.
  Future<void> lastMessageTimeToString(
      String currentUserID, UserModel chatUser) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('users')
        .doc(currentUserID)
        .collection('messages')
        .doc('$currentUserID--${chatUser.userID}')
        .collection('message')
        .orderBy('date', descending: true)
        .get();

    timeago.setLocaleMessages('tr', timeago.TrMessages());

    Map<String, dynamic> mapMessage = snapshot.docs.first.data();

    DateTime lastMessageTime = (mapMessage['date'] as Timestamp).toDate();
    DateTime? currentTime = await getCurrentTime();
    Duration _duration = currentTime!.difference(lastMessageTime);

    chatUser.diffirenceToDays = _duration.inMinutes;
    chatUser.lastMessageTimeToString =
        timeago.format(currentTime.subtract(_duration), locale: 'tr');

    return;
  }

  @override
  Future<DateTime?> getCurrentTime() async {
    return await TimeModel.getCurrentTime();
  }
}
