import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:live_chat_app/core/init/locator/global_locator.dart';
import 'package:live_chat_app/data/models/user_model.dart';
import 'package:live_chat_app/data/services/firestore_db_service.dart';
import 'package:live_chat_app/data/services/interface/auth_base.dart';
import 'package:live_chat_app/data/services/fake_auth_service.dart';
import 'package:live_chat_app/data/services/firebase_auth_service.dart';
import 'package:live_chat_app/ui/viewmodel/user_view_model.dart';

// ignore: constant_identifier_names
enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  final FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  final FakeAuthService _fakeAuthService = locator<FakeAuthService>();
  final FirestoreDbService _firebaseDbService = locator<FirestoreDbService>();

  AppMode appMode = UserViewModel.appMode;
  @override
  UserModel? currentUser() {
    if (appMode == AppMode.DEBUG) {
      return _fakeAuthService.currentUser();
    } else {
      return _firebaseAuthService.currentUser();
    }
  }

  @override
  Future<UserModel> signInAnonymously() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInAnonymously();
    } else {
      return await _firebaseAuthService.signInAnonymously();
    }
  }

  @override
  Future<bool> signOut() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signOut();
    } else {
      return await _firebaseAuthService.signOut();
    }
  }

  @override
  Future<UserModel?> signInWithGmail() async {
    return await _firebaseAuthService.signInWithGmail();
  }

  @override
  Future<UserModel?> signInWithFacebook() async {
    return await _firebaseAuthService.signInWithFacebook();
  }

  @override
  Future<UserModel?> crateUserWithEmailAndPassword(String email, String password) async {
    UserModel? _userModel = await _firebaseAuthService.crateUserWithEmailAndPassword(email, password);
    print(_userModel);
    if (_userModel != null) {
      bool result = await _firebaseDbService.saveUser(_userModel);

      if (result) {
        return _userModel;
      }
    }
    return null;
  }

  @override
  Future<UserModel?> signInWithEmailAndPassword(String email, String password) async {
    return await _firebaseAuthService.signInWithEmailAndPassword(email, password);
  }
}
