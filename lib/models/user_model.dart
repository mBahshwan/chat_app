import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? name;
  String? password;
  String? image;
  Timestamp? date;
  String? email;
  bool? isOnline;
  String? uid;
  String? token;

  UserModel(
      {required this.name,
      required this.password,
      required this.token,
      required this.email,
      required this.isOnline,
      required this.image,
      required this.date,
      required this.uid});

  factory UserModel.fromJson(Map<String, dynamic> snapshot) {
    return UserModel(
      name: snapshot['name'],
      password: snapshot['password'],
      token: snapshot['token'],
      email: snapshot['email'],
      isOnline: snapshot['isOnline'],
      image: snapshot['image'],
      date: snapshot['date'],
      uid: snapshot['uid'],
    );
  }
  Map<String, dynamic> toMap() => {
        "name": name,
        "password": password,
        "token": token,
        "email": email,
        "isOnline": isOnline,
        "image": image,
        "date": date,
        "uid": uid
      };
}
