import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/screens/user_information.dart';

class LoginServices {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<void> addUserToDatabase(UserModel userModel) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Add the data to a specific Firestore collection
      await firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(userModel.toMap());

      print('Data added to Firestore');
    } catch (e) {
      print('Error: $e');
    }
  }

  static Future<void> loginWithEmailPassword(
      UserModel userModel, BuildContext context) async {
    try {
      // Firebase authentication code
      await _auth.signInWithEmailAndPassword(
        email: userModel.email!,
        password: userModel.password!,
      );
      await addUserToDatabase(userModel);
      // Navigate to the next screen upon successful sign-in
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => UserInformation(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // Show a dialog if the user is not found
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('User Not Found'),
            content: Text('There is no user with this email address.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else if (e.code == 'wrong-password') {
        // Handle other authentication errors if needed
        // Show a dialog for wrong password
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Wrong Password'),
            content: Text('The password provided is incorrect.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // Show a generic error dialog for other exceptions
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content:
                Text('An unexpected error occurred. Please try again later.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }
}
