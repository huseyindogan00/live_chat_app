// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:live_chat_app/core/init/locator/global_locator.dart';
import 'package:live_chat_app/data/models/message_model.dart';
import 'package:live_chat_app/data/models/user_model.dart';
import 'package:live_chat_app/data/services/firebase_storage_service.dart';
import 'package:live_chat_app/data/user_repository.dart';
import 'package:live_chat_app/data/services/interface/auth_base.dart';

enum ViewState { Idle, Busy }

class UserViewModel with ChangeNotifier implements AuthBase {
  UserViewModel() {
    //currentUser();
  }

  static AppMode appMode = AppMode.DEBUG;
  ViewState _state = ViewState.Idle;

  final UserRepository _userRepository = locator<UserRepository>();
  UserModel? _userModel;

  UserModel? get userModel => _userModel;
  set userModel(UserModel? value) {
    _userModel = value;
  }

  String emailErrorMessage = '';
  String passwordErrorMessage = '';

  bool _appModeState = false;
  bool get appModeState => _appModeState;
  set appModeState(bool value) {
    _appModeState = appModeState;
  }

  set state(ViewState value) {
    _state = value;
    notifyListeners();
  }

  /// Verilen username güncelleme işlemlerinin
  Future<bool>? updateUserName(String userID, String newUserName) async {
    bool result = await _userRepository.updateUserName(userID, newUserName);
    if (result) {
      _userModel!.userName = newUserName;
    }
    return result;
  }

  ViewState get state => _state;

  @override
  Future<UserModel?> currentUser() async {
    try {
      state = ViewState.Busy;
      _userModel = await _userRepository.currentUser();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
    return null;
  }

  @override
  Future<UserModel> signInAnonymously() async {
    try {
      state = ViewState.Busy;
      _userModel = await _userRepository.signInAnonymously();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      state = ViewState.Idle;
    }
    return _userModel!;
  }

  @override
  Future<bool> signOut() async {
    bool? result;
    try {
      state = ViewState.Busy;
      result = await _userRepository.signOut();
      _userModel = result ? null : _userModel;
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      state = ViewState.Idle;
    }
    return result!;
  }

  @override
  Future<UserModel?> signInWithGmail() async {
    try {
      state = ViewState.Busy;
      _userModel = await _userRepository.signInWithGmail();
    } catch (e) {
      print(e);
    } finally {
      state = ViewState.Idle;
    }

    return _userModel;
  }

  @override
  Future<UserModel?> signInWithFacebook() async {
    try {
      state = ViewState.Busy;
      // ignore: deprecated_member_use_from_same_package
      _userModel = await _userRepository.signInWithFacebook();
    } catch (e) {
      print(e);
    } finally {
      state = ViewState.Idle;
    }
    return _userModel;
  }

  @override
  Future<UserModel?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      state = ViewState.Busy;
      _userModel = await _userRepository.createUserWithEmailAndPassword(email, password);
    } on FirebaseAuthException catch (e) {
      debugPrint('ViewModeldeki create user hatası ${e.message}');
    } finally {
      state = ViewState.Idle;
    }
    return _userModel;
  }

  @override
  Future<UserModel?> signInWithEmailAndPassword(String email, String password) async {
    try {
      state = ViewState.Busy;
      _userModel = await _userRepository.signInWithEmailAndPassword(email, password);
    } on FirebaseAuthException catch (e) {
      debugPrint('ViewModeldeki sign in with email password hatası -> ${e.message}');
    } finally {
      state = ViewState.Idle;
    }
    return _userModel;
  }

  // password kontrolü yapar
  String? passwordControl(String? value) {
    if (value != null && value.isNotEmpty) {
      if (value.length < 6) {
        return 'En az altı karakter olmalı';
      }
      return null;
    } else {
      return 'Şifre giriniz';
    }
  }

  // email kontolü yapar
  String? emailControl(String? value) {
    if (value != null && value.isNotEmpty) {
      if (!value.contains('@')) {
        return 'Geçersiz email adresi';
      }
      return null;
    } else {
      return 'Email adresi giriniz!';
    }
  }

  Future<bool> uploadFile(String? userID, StrorageFileEnum fileType, File fileToUpload) {
    return _userRepository.uploadFile(userID, fileType, fileToUpload);
  }

  Future<List<UserModel>> fetchAllUsers() {
    return _userRepository.fetchAllUsers();
  }

  Future<List<UserModel>> fetchChattedUsers(String userID) {
    return _userRepository.fetchChattedUsers(userID);
  }

  Stream<List<MessageModel>> fetchMessage(String currentUserID, String chatUserID) {
    return _userRepository.fetchMessage(currentUserID, chatUserID);
  }

  Future<bool> saveMessage(MessageModel messageModel) async {
    return _userRepository.saveMessage(messageModel);
  }

  Future<List<UserModel>> fetchUsersWithPagination(UserModel? endUserModel, int numberOfPages) async {
    return await _userRepository.fetchUsersWithPagination(endUserModel, numberOfPages);
  }
}
