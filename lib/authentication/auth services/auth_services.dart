// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_connect/authentication/onboarding/pages/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../pages/home/ui/home_page.dart';

class AuthServices with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isLoading = false;

  void showAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            message,
            style: const TextStyle(fontSize: 16),
          ),
        );
      },
    );
  }

  Future<void> signIn(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      isLoading = true;
      notifyListeners();

      if (email.isEmpty || password.isEmpty) {
        showAlertDialog(context, 'Fill Required Fields');
      } else {
        await _firebaseAuth
            .signInWithEmailAndPassword(
          email: email,
          password: password,
        )
            .then((_) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const BottomNavBar(),
              ),
              (route) => false);
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        showAlertDialog(context, 'Email or password in incorrect');
      }
      log(e.message!, name: 'AuthServices SignIn Error');
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required int phoneNo,
    required BuildContext context,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      if (name.isEmpty ||
          email.isEmpty ||
          password.isEmpty ||
          phoneNo.toString().isEmpty) {
        showAlertDialog(context, 'Fill Required Fields');
      } else {
        final UserCredential userCredential =
            await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        _firestore.collection('users').doc(userCredential.user!.uid).set({
          'name': name,
          'email': email,
          'uid': userCredential.user!.uid,
          'numberOfYourOrg': 0,
          'phone': phoneNo,
        });

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const BottomNavBar(),
          ),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      showAlertDialog(context, e.code);
      log(e.message!, name: 'AuthServices SignUp Error');
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> signOut(BuildContext context) async {
    await _firebaseAuth.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const SignInPage(),
      ),
      (route) => false,
    );
  }

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
}
