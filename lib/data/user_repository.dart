import 'dart:io';

import 'package:live_chat_app/core/init/locator/global_locator.dart';
import 'package:live_chat_app/data/models/message_model.dart';
import 'package:live_chat_app/data/models/user_model.dart';
import 'package:live_chat_app/data/services/firebase_storage_service.dart';
import 'package:live_chat_app/data/services/firestore_db_service.dart';
import 'package:live_chat_app/data/services/interface/auth_base.dart';
import 'package:live_chat_app/data/services/firebase_auth_service.dart';

// ignore: constant_identifier_names
enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  final FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  final FirestoreDbService _firebaseDbService = locator<FirestoreDbService>();
  final FirebaseStorageService _firebaseStorageService = locator<FirebaseStorageService>();

  ///Herhani bir kullanıcının olup olmamasını kontrol eder.
  @override
  Future<UserModel?> currentUser() async {
    UserModel? userModel = await _firebaseAuthService.currentUser();
    if (userModel != null) {
      return await _firebaseDbService.readUser(userModel.userID!);
    }
    return null;
  }

  @override
  Future<UserModel> signInAnonymously() async {
    return await _firebaseAuthService.signInAnonymously();
  }

  @override
  Future<bool> signOut() async {
    return await _firebaseAuthService.signOut();
  }

  @override
  Future<UserModel?> signInWithGmail() async {
    UserModel? _userModel = await _firebaseAuthService.signInWithGmail();

    if (_userModel != null) {
      bool result = await _firebaseDbService.saveUser(_userModel);

      _userModel = await _firebaseDbService.readUser(_userModel.userID!);
    }
    return _userModel;
  }

  @Deprecated('Facebook ile bağlantı başarısız oldu. Gerekli bağlantılar yapılacaktır.')
  @override
  Future<UserModel?> signInWithFacebook() async {
    //return await _firebaseAuthService.signInWithFacebook();
  }

  ///
  ///Verilen `email` ve `password` bilgilerini   Firebase Authentication ve Firestore kayıt eder.
  ///
  ///Kaydedilen kullanıcı bilgilerini Firestore'dan okuyarak geriye UserModel döner.
  @override
  Future<UserModel?> createUserWithEmailAndPassword(String email, String password) async {
    UserModel? _userModel = await _firebaseAuthService.createUserWithEmailAndPassword(email, password);

    if (_userModel != null) {
      bool result = await _firebaseDbService.saveUser(_userModel);

      if (result) {
        _userModel = await _firebaseDbService.readUser(_userModel.userID!);
        return _userModel;
      }
    }
    return null;
  }

  ///
  ///Verilen `email` ve `password` bilgisini Firebase Authentication da olup olmadığını kontrol eder.
  ///
  ///Eğer bilgiler doğruysa, Firestore'dan mevcut kullanıcı bilgilerini okur ve geriye UserModel döner.
  @override
  Future<UserModel?> signInWithEmailAndPassword(String email, String password) async {
    UserModel? _userModel = await _firebaseAuthService.signInWithEmailAndPassword(email, password);
    if (_userModel != null) {
      _userModel = await _firebaseDbService.readUser(_userModel.userID!);
    }
    return _userModel;
  }

  Future<bool> updateUserName(String userID, String newUserName) async {
    return await _firebaseDbService.updateUserName(userID, newUserName);
  }

  Future<bool> uploadFile(String? userID, StrorageFileEnum fileType, File fileToUpload) async {
    String url = await _firebaseStorageService.uploadFile(userID!, fileType, fileToUpload);
    bool result = await _firebaseDbService.updatePhotoUrl(userID, url);
    return result;
  }

  Future<List<UserModel>> getAllUsers() async {
    return await _firebaseDbService.getAllUsers();
  }

  Stream<List<MessageModel>> getMessages(String currentUserID, String chatUserID) {
    return _firebaseDbService.getMessage(currentUserID, chatUserID);
  }

  Future<bool> saveMessage(MessageModel messageModel) async {
    return await _firebaseDbService.saveMessage(messageModel);
  }
}
