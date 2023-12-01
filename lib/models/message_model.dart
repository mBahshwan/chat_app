import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String lastMessage;
  final String uid;

  MessageModel({required this.lastMessage, required this.uid});

  factory MessageModel.fromJson(DocumentSnapshot message) =>
      MessageModel(lastMessage: message['last_msg'], uid: message.id);

  Map<String, dynamic> toJson() => {"last_msg": lastMessage, "uid": uid};
}
