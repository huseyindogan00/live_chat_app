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
    return await _firebaseAuthService.signInWithFacebook();
  }

  ///
  ///Verilen `email` ve `password` bilgilerini   Firebase Authentication ve Firestore kayıt eder.
  ///
  ///Kaydedilen kullanıcı bilgilerini Firestore'dan okuyarak geriye UserModel döner.
  @override
  Future<UserModel?> crateUserWithEmailAndPassword(String email, String password) async {
    UserModel? _userModel = await _firebaseAuthService.crateUserWithEmailAndPassword(email, password);

    if (_userModel != null) {
      bool result = await _firebaseDbService.saveUser(_userModel);

      if (result) {
        await _firebaseDbService.readUser(_userModel.userID!);
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
}
