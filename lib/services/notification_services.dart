import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:whatsapp_clone/screens/chat_screen.dart';

class NotificationServices {
  static const key = "API_KEY_HERE ";
  final flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();
  void _initLocalNotification() {
    const andriodSettings = AndroidInitializationSettings("chat_icon");
    const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestCriticalPermission: true,
        requestSoundPermission: true);
    const initializationSettings =
        InitializationSettings(android: andriodSettings, iOS: iosSettings);
    flutterLocalNotificationPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint(details.payload.toString());
      },
    );
  }

  Future<void> _showNotification(RemoteMessage message) async {
    final styleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title,
        htmlFormatContentTitle: true);
    final andriodDetails = AndroidNotificationDetails(
        "com.example.whatsapp_clone", "myChannelId",
        importance: Importance.max,
        priority: Priority.max,
        styleInformation: styleInformation);
    const iosDetails =
        DarwinNotificationDetails(presentAlert: true, presentBadge: true);
    final notificationDetails =
        NotificationDetails(android: andriodDetails, iOS: iosDetails);
    await flutterLocalNotificationPlugin.show(0, message.notification!.title,
        message.notification!.body, notificationDetails,
        payload: message.data['body']);
  }

  Future<void> requestPermission() async {
    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: true,
        criticalAlert: false,
        provisional: false,
        sound: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint("user granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint("user granted provisional permission");
    } else {
      debugPrint("user declinet has not accepted permission");
    }
  }

  Future<void> getTokent() async {
    final token = await FirebaseMessaging.instance.getToken();
    await _saveToken(token!);
  }

  Future<void> _saveToken(String token) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({"token": token}, SetOptions(merge: true));
  }

  String receiverToken = '';
  Future<void> getReceiverToken(String? receiverid) async {
    final getToken = await FirebaseFirestore.instance
        .collection("users")
        .doc(receiverid)
        .get();
    receiverToken = await getToken.data()!['token'];
  }

  void firebaseNotification(
      BuildContext context,
      bool isOnline,
      DateTime date,
      String friendId,
      String friendName,
      String friendImage,
      String friendEmail) {
    _initLocalNotification();
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => ChatScreen(
      //           isOnline: isOnline,
      //           date: date,
      //           friendId: friendId,
      //           friendName: friendName,
      //           friendImage: friendImage),
      //     ));
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
                friendEmail: friendEmail,
                isOnline: isOnline,
                date: date,
                friendId: friendId,
                friendName: friendName,
                friendImage: friendImage),
          ),
          (route) => false);
    });
    FirebaseMessaging.onMessage.listen((event) {
      _showNotification(event);
    });
  }

  Future<void> sendNotification({
    required String body,
    required String senderId,
  }) async {
    try {
      await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
          headers: <String, String>{
            "Content-Type": "application/json",
            "Authorization": "key=$key"
          },
          body: jsonEncode(<String, dynamic>{
            "to": receiverToken,
            "priority": "high",
            "notification": {
              "body": body,
              "title": "new message !",
            },
            "data": {
              "click_action": "FLUTTER_NOTIFICATION_CLICK",
              "status": "done",
              "senderId": senderId
            }
          }));
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
