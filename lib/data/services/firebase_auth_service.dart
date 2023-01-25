// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:live_chat_app/data/models/user_model.dart';
import 'package:live_chat_app/data/services/interface/auth_base.dart';

class FirebaseAuthService implements AuthBase {
  final FirebaseAuth _firebaseAuthService = FirebaseAuth.instance;
  @override
  Future<UserModel?> currentUser() async {
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
          email: userCredential.user?.email,
          userName: userCredential.user?.displayName,
          phoneNumber: userCredential.user?.phoneNumber,
          photoUrl: userCredential.user?.photoURL,
        );
      }
    }
    return null;
  }

  @override
  Future<UserModel?> signInWithFacebook() async {
    final _facebookLogin = await FacebookLogin().logIn();

    //final result = await _facebookLogin.logIn();
    switch (_facebookLogin.status) {
      case FacebookLoginStatus.success:
        final FacebookAccessToken? accessToken = await _facebookLogin.accessToken;
        if (accessToken != null) {
          UserCredential firebaseResult =
              await _firebaseAuthService.signInWithCredential(FacebookAuthProvider.credential(accessToken.token));
          return UserModel(
            email: firebaseResult.user!.email,
            photoUrl: firebaseResult.user!.photoURL,
            userName: firebaseResult.user!.displayName,
          );
        }
        //final profile = await _fb.getUserProfile();

        break;
      case FacebookLoginStatus.error:
        print(_facebookLogin.error!.developerMessage.toString());
        break;
      case FacebookLoginStatus.cancel:
        break;
      default:
        print(_facebookLogin.status);
    }
    return null;
  }

  @override
  Future<UserModel?> crateUserWithEmailAndPassword(String email, String password) async {
    UserCredential _userCredential =
        await _firebaseAuthService.createUserWithEmailAndPassword(email: email, password: password);

    if (_userCredential.user != null) {
      return UserModel(
        email: _userCredential.user!.email,
        userName: _userCredential.user!.displayName,
        phoneNumber: _userCredential.user!.phoneNumber,
        photoUrl: _userCredential.user!.photoURL,
        userID: _userCredential.user!.uid,
      );
    }
    return null;
  }

  @override
  Future<UserModel?> signInWithEmailAndPassword(String email, String password) async {
    UserCredential _userCredential =
        await _firebaseAuthService.signInWithEmailAndPassword(email: email, password: password);

    if (_userCredential.user != null) {
      return UserModel(
        email: _userCredential.user!.email,
        userName: _userCredential.user!.displayName,
        phoneNumber: _userCredential.user!.phoneNumber,
        photoUrl: _userCredential.user!.photoURL,
        userID: _userCredential.user!.uid,
      );
    }
    return null;
  }
}
