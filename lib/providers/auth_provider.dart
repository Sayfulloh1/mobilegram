
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobilegram/services/snackbar_service.dart';



class AuthProvider extends ChangeNotifier {
  static AuthProvider instance = AuthProvider();



  FirebaseAuth _auth = FirebaseAuth.instance;
  late User user;
  bool isAuthenticated = false;
  bool isAuthenticating = false;
  AuthProvider() {
    _auth = FirebaseAuth.instance;
  }

  void loginUserWithEmailAndPassword(String email, String password) async {
    isAuthenticating = true;

    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = credential.user!;
      isAuthenticated = true;
      notifyListeners();





      //Navigate to HomeScreen
    } catch (error) {



    }
    notifyListeners();
  }

  void registerUserWithEmailAndPassword(
    String email,
    String password,
    Future<void> Function(String uuid) onSuccess,
  ) async {


    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
       user = result.user!;
       print('user uuid is ${user.uid}');
       await onSuccess(user.uid);
       print('Succes in creating user');

      //Navigate to HomeScreen
    } catch (error) {
      // user = null;
      print('Succes in creating user');

    }
  }
}
