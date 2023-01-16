// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:live_chat_app/core/init/locator/global_locator.dart';
import 'package:live_chat_app/data/models/user_model.dart';
import 'package:live_chat_app/data/user_repository.dart';
import 'package:live_chat_app/data/services/interface/auth_base.dart';

enum ViewState { Idle, Busy }

class UserViewModel with ChangeNotifier implements AuthBase {
  UserViewModel() {
    currentUser();
  }

  static AppMode appMode = AppMode.DEBUG;
  ViewState _state = ViewState.Idle;

  final UserRepository _userRepository = locator<UserRepository>();
  UserModel? _userModel;

  UserModel? get userModel => _userModel;
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

  ViewState get state => _state;

  @override
  UserModel? currentUser() {
    try {
      state = ViewState.Busy;
      _userModel = _userRepository.currentUser();
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
      _userModel = await _userRepository.signInWithFacebook();
    } catch (e) {
      print(e);
    } finally {
      state = ViewState.Idle;
    }
    return _userModel;
  }

  @override
  Future<UserModel?> crateUserWithEmailAndPassword(String email, String password) async {
    try {
      state = ViewState.Busy;

      _userModel = await _userRepository.crateUserWithEmailAndPassword(email, password);
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

  // password validation yapar
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

  // email validation yapar
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

  // DEBUG(hata ayıklama)  ve RELEASE(yayınlama) modları arasında geçişi kontrol eder
  void changeAppMode(bool value) {
    _appModeState = value;
    _userRepository.appMode = _appModeState ? AppMode.RELEASE : AppMode.DEBUG;
    appMode = _appModeState ? AppMode.RELEASE : AppMode.DEBUG;
    notifyListeners();
  }
}
