import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:whatsapp_clone/common/utils.dart/snakbar.dart';
import 'package:whatsapp_clone/main.dart';

import 'package:whatsapp_clone/models/user_model.dart';

import 'package:whatsapp_clone/services/userInformatioServices.dart';

class UserInformationViewmodel extends ChangeNotifier {
  File? _image;
  String _downloadUrl = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//  static FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> editprofile(
    String downloadUrl,
    String name,
    String id,
    String password,
    String email,
  ) async {
    await UserInformationServices.editProfile(
      downloadUrl,
      name,
      id,
      password,
      email,
    );
  }

  Future<void> pickImageFromGallery(BuildContext context) async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        _image = File(pickedImage.path);
        print(_image!.path);
        notifyListeners();
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
    // notifyListeners();
  }

  Future<void> storeFileToFirebase(File file, String name, String uid,
      String password, String email, BuildContext context) async {
    FocusScope.of(context).unfocus();
    _downloadUrl = await UserInformationServices.storeFileToFirebase(
        file, name, uid, password, email, context);
    await Future.delayed(Duration(seconds: 5));
    await notificationService.getTokent();
    print("got token ==============");

    // return _downloadUrl;
  }

  static Future<UserModel> getCurrentUserData() async {
    return UserInformationServices.getCurrentUserData().then((value) =>
        value.firstWhere((element) =>
            element.email == FirebaseAuth.instance.currentUser!.email));
  }

  File? get image => _image;
  GlobalKey<FormState> get formKey => _formKey;
  String get downloadUrl => _downloadUrl;
}
