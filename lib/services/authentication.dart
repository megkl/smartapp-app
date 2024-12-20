import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password,String name);

  Future<User> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    User user = result.user!;
    return user.uid;
  }

  Future<String> signUp(String email, String password,String name) async {
    UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    User user = result.user!;


    await FirebaseAuth.instance.currentUser!.updateProfile(displayName:user.displayName);


    try {
      await user.sendEmailVerification();
      return user.uid;
    } catch (e) {

  
  


      AuthCredential authCredential = EmailAuthProvider.credential
      
      (email: email,password: password);

      user.reauthenticateWithCredential(authCredential);

      user.delete();


    }

    return user.uid;
  }

  Future<User> getCurrentUser() async {
    User user = _firebaseAuth.currentUser!;
    return user;
  }



  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    User user = _firebaseAuth.currentUser!;
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    User user = _firebaseAuth.currentUser!;
    return user.emailVerified;
  }
}
