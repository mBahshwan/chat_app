import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/main.dart';
import 'package:whatsapp_clone/screens/home_screen.dart';
import 'package:whatsapp_clone/viewModels/chat_viewmodel.dart';
import 'package:whatsapp_clone/widgets/message_textfield.dart';
import 'package:whatsapp_clone/widgets/single_message.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class ChatScreen extends StatefulWidget {
  // final UserModel currentUser;
  final String friendId;
  final String friendName;
  final String friendImage;
  final bool isOnline;
  final String friendEmail;
  final DateTime date;

  ChatScreen({
    //   required this.currentUser,
    required this.isOnline,
    required this.friendEmail,
    required this.date,
    required this.friendId,
    required this.friendName,
    required this.friendImage,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    notificationService.getReceiverToken(widget.friendId);
    notificationService.firebaseNotification(
        context,
        widget.isOnline,
        widget.date,
        widget.friendId,
        widget.friendName,
        widget.friendImage,
        widget.friendEmail);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomeScreen())),
            icon: Icon(
              Icons.arrow_back,
              color: textColor,
            )),
        actions: [
          ZegoSendCallInvitationButton(
            buttonSize: Size(40, 40),
            iconSize: Size(40, 40),
            isVideoCall: true,
            resourceID:
                "zego_cloud", //You need to use the resourceID that you created in the subsequent steps. Please continue reading this document.
            invitees: [
              ZegoUIKitUser(
                id: widget.friendId,
                name: widget.friendEmail,
              ),
            ],
          ),
          SizedBox(
            width: 20,
          ),
          ZegoSendCallInvitationButton(
            buttonSize: Size(40, 40),
            iconSize: Size(40, 40),

            isVideoCall: false,
            resourceID:
                "zego_cloud", //You need to use the resourceID that you created in the subsequent steps. Please continue reading this document.
            invitees: [
              ZegoUIKitUser(
                id: widget.friendId,
                name: widget.friendEmail,
              ),
            ],
          ),
          SizedBox(
            width: 5,
          ),
        ],
        backgroundColor: chatBarMessage,
        title: Row(
          children: [
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(80),
            //   child: CachedNetworkImage(
            //     imageUrl: friendImage,
            //     placeholder: (conteext, url) => CircularProgressIndicator(),
            //     errorWidget: (context, url, error) => Icon(
            //       Icons.error,
            //     ),
            //     height: 40,
            //   ),
            // ),
            CircleAvatar(
              backgroundImage: NetworkImage(widget.friendImage),
            ),
            SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.friendName,
                  style: TextStyle(fontSize: 20, color: textColor),
                ),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(widget.friendId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          snapshot.data!["isOnline"] == true
                              ? "online"
                              : "last seen : ${Provider.of<ChatViewmodel>(context).formatTimeAgo(widget.date)}",
                          style: snapshot.data!["isOnline"] == true
                              ? TextStyle(fontSize: 15, color: tabColor)
                              : TextStyle(fontSize: 13, color: greyColor),
                        );
                      }
                      return Text(
                        "no data",
                        style: TextStyle(color: textColor),
                      );
                    })
                // widget.isOnline
                //  Text(
                //     "online",
                //     style: TextStyle(fontSize: 15, color: tabColor),
                //   )
                //     : Text(
                //         "last seen : ${Provider.of<ChatViewmodel>(context).formatTimeAgo(widget.date)}",
                //         style: TextStyle(fontSize: 15, color: greyColor),
                //       )
              ],
            )
          ],
        ),
      ),
      body: InkWell(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Expanded(
                child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25))),
              child: StreamBuilder(
                  stream: Provider.of<ChatViewmodel>(context)
                      .viewChat(widget.friendId),
                  // FirebaseFirestore.instance
                  //     .collection("users")
                  //     .doc(FirebaseAuth.instance.currentUser!.uid)
                  //     .collection('messages')
                  //     .doc(friendId)
                  //     .collection('chats')
                  //     .orderBy("date", descending: true)
                  //     .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      // ignore: prefer_is_empty
                      if (snapshot.data!.length < 1) {
                        return Center(
                          child: Text(
                            "Say Hi",
                            style: TextStyle(color: textColor),
                          ),
                        );
                      }
                      return ListView.builder(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          itemCount: snapshot.data!.length,
                          reverse: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            bool isMe = snapshot.data![index].senderId ==
                                FirebaseAuth.instance.currentUser!.uid;
                            return SingleMessage(
                                date: snapshot.data![index].date,
                                message: snapshot.data![index].message,
                                isMe: isMe);
                          });
                    }
                    return Center(child: CircularProgressIndicator());
                  }),
            )),
            MessageTextField(
                FirebaseAuth.instance.currentUser!.uid, widget.friendId),
          ],
        ),
      ),
    );
  }
}
