import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whatsapp_clone/common/utils.dart/snakbar.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/screens/login_screen.dart';

class SignUpServices {
  static Future<void> signUp(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        showSnackBar(context: context, content: "You can login now !!");
        await Future.delayed(Duration(seconds: 1));
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
            (route) => false);
      } else {
        AwesomeDialog(
                alignment: Alignment.center,
                context: context,
                title: "one more step",
                body: Text(
                    " we have sent a verification to your email please verify and come back"))
            .show();
      }

      // You can also sign in the user or show a confirmation message here
    } on PlatformException catch (e) {
      print("Error: $e");
      AwesomeDialog(
              context: context, title: "erorr", body: Text("${e.message}"))
          .show();
      // Handle signup errors
    }
  }

  static Future<void> addUserToDatabase(UserModel userModel, String id) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Add the data to a specific Firestore collection
      await firestore.collection('users').doc(id).set(userModel.toMap());

      print('Data added to Firestore');
    } catch (e) {
      print('Error: $e');
    }
  }
}
