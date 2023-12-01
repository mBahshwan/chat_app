import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/models/user_model.dart';

class SearchServices {
  static Future<List<UserModel>> getUsersToSearch(
      String currentName, BuildContext context) async {
    List<UserModel> searchResult = [];
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .where("nickName", isEqualTo: currentName)
          .get()
          .then((value) {
        if (value.docs.length < 1) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("No User Found")));

          return;
        }
        value.docs.forEach((user) {
          searchResult
              .add(UserModel.fromJson(Map<String, dynamic>.from(user.data())));
          // print(searchResult);
        });
        // searchResult =
        //     value.docs.map((e) => UserModel.fromJson(e.data())).toList();
      });
    } catch (e) {
      print("$e");
    }

    return searchResult;
  }
}
