import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/models/message_model.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/services/homeScreen_services.dart';

class HomeViewmodel extends ChangeNotifier {
  Future<UserModel> getCurrentUserData() async {
    return await HomeScreeServices.getCurrentUserData().then((value) =>
        value.firstWhere((element) =>
            element.email == FirebaseAuth.instance.currentUser!.email));
  }

  Stream<List<MessageModel>> getAllMessageStream() {
    return HomeScreeServices.getAllMessages();
  }

  Future<UserModel> getFriend(String friendId) =>
      HomeScreeServices.getFriend(friendId);

  Future<void> updateUserData(Map<String, dynamic> data) async =>
      await HomeScreeServices.updateUserData(data);
}
