import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthServices {
  final _firebaseAuth = FirebaseAuth.instance;
  User? _user;

  Future loginWithEmail(
      {required String email, required String password}) async {
    try {
      var authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = authResult.user;
      return authResult != null;
    } catch (e) {
      if (e is FirebaseException) {
        return e.message;
      }
      return e;
    }
  }

  Future signUpWithEmail(
      {required String email, required String password}) async {
    try {
      var authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = authResult.user;
      return authResult.user != null;
    } catch (e) {
      if (e is FirebaseException) {
        return e.message;
      }
      return e;
    }
  }

  getCurrentUser() {
    var user = _firebaseAuth.currentUser;
    return user;
  }

  Future changePassword(
      {required String oldpassword, required String password}) async {
    var user = _firebaseAuth.currentUser;
    if (user != null) {
      final authResult = await user.reauthenticateWithCredential(
        EmailAuthProvider.credential(email: user.email!, password: oldpassword),
      );
      if (authResult is UserCredential) {
        final results = await user.updatePassword(password);
        return results;
      } else {
        print(
            "object----------------------------_______>${authResult.user!.email!}");
        return authResult;
      }
    }
  }

  Future changeEmail({required String email, required String password}) async {
    var user = _firebaseAuth.currentUser;
    if (user != null) {
      final authResult = await user.reauthenticateWithCredential(
        EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        ),
      );
      if (authResult is UserCredential) {
        final results = await user.updateEmail(email);
        return results;
      } else {
        print("object----------------------------_______>$authResult");
        return authResult;
      }
    }
  }

  Future<User?> getFirebaseCurrentUser() async {
    return _firebaseAuth.currentUser;
  }

  Future<bool> signOut() async {
    await _firebaseAuth.signOut();
    var user = await getFirebaseCurrentUser();
    if (user != null) {
      return false;
    } else {
      return true;
    }
  }

  User? get user {
    return _user;
  }
}

AuthServices auth = AuthServices();
