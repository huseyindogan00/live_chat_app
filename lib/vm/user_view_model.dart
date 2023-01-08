// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/cupertino.dart';
import 'package:live_chat_app/core/init/locator/global_locator.dart';
import 'package:live_chat_app/models/user_model.dart';
import 'package:live_chat_app/data/user_repository.dart';
import 'package:live_chat_app/data/interface/auth_base.dart';

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

  changeAppMode(bool value) {
    _appModeState = value;
    _userRepository.appMode = _appModeState ? AppMode.RELEASE : AppMode.DEBUG;
    appMode = _appModeState ? AppMode.RELEASE : AppMode.DEBUG;
    notifyListeners();
  }

  @override
  Future<UserModel> signInWithGmail() {
    // TODO: implement signInWithGmail
    throw UnimplementedError();
  }
}
