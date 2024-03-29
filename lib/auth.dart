import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
// Google Firebase authentication for authorization/login

abstract class BaseAuth {
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> createUserWithEmailAndPassword(String email, String password);
  Future<String> currentUser();
  Future<void> signOut();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<String> signInWithEmailAndPassword(String email, String password) async {
    // TODO: implement signInWithEmailAndPassword
    FirebaseUser user = (await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user;
    return user.uid;
  }

  @override
  Future<String> createUserWithEmailAndPassword(String email, String password) async {
    // TODO: implement createUserWithEmailAndPassword
    FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user;
    return user.uid;
  }

  @override
  Future<String> currentUser() async {
    FirebaseUser user = (await _firebaseAuth.currentUser());
    if (user == null) {
      return null;
    } else {
      return user.uid;
    }
  }

  @override
  Future<void> signOut() async {
   return _firebaseAuth.signOut();
  }

}