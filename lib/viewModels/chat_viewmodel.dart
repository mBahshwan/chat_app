import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/main.dart';
import 'package:whatsapp_clone/models/caht_model.dart';
import 'package:whatsapp_clone/services/chat_services.dart';

class ChatViewmodel extends ChangeNotifier {
  Stream<List<ChatModel>> viewChat(String friendId) =>
      ChatServices.viewChat(friendId);

  Future<void> makeMessage(
      String message, ChatModel chat, BuildContext context) async {
    ChatServices.sendMessage(message, chat);
    ChatServices.receiveMessage(message, chat);
    await notificationService.sendNotification(
        body: message, senderId: FirebaseAuth.instance.currentUser!.uid);
    FocusScope.of(context).unfocus();
  }

  String formatTimeAgo(DateTime dateTime) {
    final Duration difference = DateTime.now().difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'a few seconds ago';
    } else if (difference.inMinutes == 1) {
      return 'a minute ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours == 1) {
      return 'an hour ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'a day ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('dd/MM/yyyy').format(dateTime);
    }
  }
}
