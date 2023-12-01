import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsapp_clone/models/message_model.dart';
import 'package:whatsapp_clone/models/user_model.dart';

class HomeScreeServices {
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static Future<List<UserModel>> getCurrentUserData() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection("users").get();
    return snapshot.docs.map((e) => UserModel.fromJson(e.data())).toList();
  }

  static Stream<List<MessageModel>> getAllMessages() {
    return _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("messages")
        .snapshots()
        .map((snapshot) {
      print("$snapshot =========");
      return snapshot.docs.map((doc) => MessageModel.fromJson(doc)).toList();
    });
  }

  static Future<UserModel> getFriend(String friendId) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection("users").doc(friendId).get();
    return UserModel.fromJson(snapshot.data()!);
  }

  static Future<void> updateUserData(Map<String, dynamic> data) async {
    await _firestore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(data);
    print("+++++++++++ USER DATA UPDATED +++++++++++");
  }
}
