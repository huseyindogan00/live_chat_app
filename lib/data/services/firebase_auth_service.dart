// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:live_chat_app/models/user_model.dart';
import 'package:live_chat_app/data/interface/auth_base.dart';

class FirebaseAuthService implements AuthBase {
  final FirebaseAuth _firebaseAuthService = FirebaseAuth.instance;
  @override
  UserModel? currentUser() {
    UserModel? _userModel;
    try {
      User? user = _firebaseAuthService.currentUser;
      _userModel = _userFromFirebase(user)!;
    } catch (e) {
      print(e.toString());
    }
    return _userModel;
  }

  @override
  Future<UserModel> signInAnonymously() async {
    late UserCredential _userCredential;
    late UserModel _userModel;

    try {
      _userCredential = await _firebaseAuthService.signInAnonymously();
      _userModel = _userFromFirebase(_userCredential.user) ?? UserModel(userID: 'boş');
    } catch (e) {
      print(e.toString());
    }
    return _userModel;
  }

  @override
  Future<bool> signOut() async {
    final googleSignIn = GoogleSignIn();
    try {
      if (await googleSignIn.isSignedIn()) await googleSignIn.signOut();
      await _firebaseAuthService.signOut();
    } catch (e) {
      print(e.toString());
      return false;
    }
    return true;
  }

  UserModel? _userFromFirebase(User? userCredential) {
    if (userCredential != null) {
      UserModel userModel = UserModel(userID: userCredential.uid);
      return userModel;
    }
    return null;
  }

  @override
  Future<UserModel?> signInWithGmail() async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    GoogleSignInAccount? _googleUser = await _googleSignIn.signIn();

    if (_googleUser != null) {
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      if (_googleAuth.idToken != null && _googleAuth.accessToken != null) {
        final UserCredential userCredential = await _firebaseAuthService.signInWithCredential(
            GoogleAuthProvider.credential(accessToken: _googleAuth.accessToken, idToken: _googleAuth.idToken));

        return UserModel(
          userID: userCredential.user?.uid,
          gmail: userCredential.user?.email,
          name: userCredential.user?.displayName,
          phoneNumber: userCredential.user?.phoneNumber,
          photoUrl: userCredential.user?.photoURL,
        );
      }
    }
    return null;
  }
}
