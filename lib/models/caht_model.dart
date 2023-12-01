import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final DateTime date;
  final String message;
  final String senderId;
  final String receiverId;
  final String type;
  ChatModel(
      {required this.date,
      required this.message,
      required this.senderId,
      required this.receiverId,
      required this.type});

  factory ChatModel.fromJson(Map<String, dynamic> message) => ChatModel(
      date: (message["date"] as Timestamp).toDate(),
      message: message["message"],
      receiverId: message["receiverId"],
      senderId: message["senderId"],
      type: message["type"]);

  Map<String, dynamic> toJson() => {
        "date": date,
        "message": message,
        "receiverId": receiverId,
        "senderId": senderId,
        "type": type
      };
}
