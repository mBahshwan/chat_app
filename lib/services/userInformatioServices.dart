import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whatsapp_clone/main.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/screens/home_screen.dart';

class UserInformationServices {
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static Future<void> editProfile(
    String downloadUrl,
    String name,
    String uid,
    String password,
    String email,
  ) async {
    await _firestore.collection("users").doc(uid).set({
      "name": name.trim(),
      "email": email.trim(),
      "uid": FirebaseAuth.instance.currentUser!.uid,
      "date": Timestamp.fromDate(DateTime.now()),
      "image": downloadUrl,
      "password": password.trim(),
      "isOnline": false
    }).then(
        (value) => print("______________________DONE_____________________"));
  }

  static Future<String> storeFileToFirebase(File file, String name, String uid,
      String password, String email, BuildContext context) async {
    String downloadUrl = "";
    try {
      final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
      String fileName = file.path.split('/').last;
      UploadTask uploadTask =
          firebaseStorage.ref().child("ProfilePics/$fileName").putFile(file);
      TaskSnapshot snap = await uploadTask;
      downloadUrl = await snap.ref.getDownloadURL();
      await Future.delayed(Duration(seconds: 5));

      print("Going to add URL");
      print(
          "========================================$downloadUrl ===================================");
      await editProfile(downloadUrl, name, uid, password, email);
      print("URL ADDED");

      sharedPreferences!.setBool("editComplete", true);
      print(sharedPreferences!.getBool("editComplete"));

      if (downloadUrl.isNotEmpty) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      }
    } on PlatformException catch (e) {
      print("======$e======");
    }
    return downloadUrl;

    // await Future.delayed(Duration(seconds: 5));
    // return _downloadUrl;
  }

  static Future<List<UserModel>> getCurrentUserData() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection("users").get();
    return snapshot.docs.map((e) => UserModel.fromJson(e.data())).toList();
  }
}
