import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/models/user_model.dart';

class SearchViewmodel extends ChangeNotifier {
  List<UserModel> _searchResult = [];
  bool _isLoading = false;
  Future<void> getUsersToSearch(
      String currentName, BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();
      await FirebaseFirestore.instance
          .collection('users')
          .where("nickName", isEqualTo: currentName)
          .get()
          .then((value) {
        if (value.docs.length < 1) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("No User Found")));
        }
        value.docs.forEach((user) {
          _searchResult
              .add(UserModel.fromJson(Map<String, dynamic>.from(user.data())));
          _isLoading = false;
          print(_isLoading);
          print(_searchResult);
          notifyListeners();
          // print(searchResult);
        });
        // searchResult =
        //     value.docs.map((e) => UserModel.fromJson(e.data())).toList();
      });
    } catch (e) {
      print("$e");
    }
  }

  List<UserModel> get searchResult => _searchResult;
  bool get isLoading => _isLoading;
}
