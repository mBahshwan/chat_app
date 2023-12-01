import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsapp_clone/models/caht_model.dart';

class ChatServices {
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static Stream<List<ChatModel>> viewChat(String friendId) {
    Stream<QuerySnapshot<Map<String, dynamic>>> snapshot = _firestore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('messages')
        .doc(friendId)
        .collection('chats')
        .orderBy("date", descending: true)
        .snapshots();

    return snapshot.map((QuerySnapshot<Map<String, dynamic>> event) {
      List<ChatModel> chatList = [];
      event.docs.forEach((doc) {
        chatList.add(ChatModel.fromJson(doc.data()));
      });
      return chatList;
    });
  }

  static Future<void> sendMessage(String message, ChatModel chat) async {
    await _firestore
        .collection('users')
        .doc(chat.senderId)
        .collection('messages')
        .doc(chat.receiverId)
        .collection('chats')
        .add(chat.toJson())
        .then((value) {
      _firestore
          .collection('users')
          .doc(chat.senderId)
          .collection('messages')
          .doc(chat.receiverId)
          .set({'last_msg': message});
    });
  }

  static Future<void> receiveMessage(String message, ChatModel chat) async {
    await _firestore
        .collection('users')
        .doc(chat.receiverId)
        .collection('messages')
        .doc(chat.senderId)
        .collection('chats')
        .add(chat.toJson())
        .then((value) {
      _firestore
          .collection('users')
          .doc(chat.receiverId)
          .collection('messages')
          .doc(chat.senderId)
          .set({'last_msg': message});
    });
  }
}
