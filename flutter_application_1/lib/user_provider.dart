import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider with ChangeNotifier {
  Future<void> createAccount({
    required String email,
    required String password,
    required String username,
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': email,
          'username': username,
        });
        notifyListeners();
      }
    } on FirebaseAuthException catch (e) {
      throw Exception("Account creation failed: ${e.message}");
    }
  }

  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      throw Exception("Login failed: ${e.message}");
    }
  }

  void logout() {
    notifyListeners();
  }
}
