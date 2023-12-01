import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/common/colors.dart';
import 'package:whatsapp_clone/models/caht_model.dart';
import 'package:whatsapp_clone/viewModels/chat_viewmodel.dart';

class MessageTextField extends StatefulWidget {
  final String currentId;
  final String friendId;

  MessageTextField(this.currentId, this.friendId);

  @override
  _MessageTextFieldState createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      padding: EdgeInsetsDirectional.all(8),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: _controller,
            decoration: InputDecoration(
                hintText: "Type your Message",
                fillColor: Colors.grey[100],
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: blackColor), // Change the border color here
                  borderRadius: BorderRadius.circular(20.0), // Border radius
                ),
                filled: true,
                border: OutlineInputBorder(
                    borderSide: BorderSide(width: 0),
                    gapPadding: 10,
                    borderRadius: BorderRadius.circular(25))),
          )),
          SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () async {
              String message = _controller.text;
              ChatModel chat = ChatModel(
                  date: DateTime.now(),
                  message: message,
                  senderId: widget.currentId,
                  receiverId: widget.friendId,
                  type: "text");

              _controller.clear();
              Provider.of<ChatViewmodel>(context, listen: false)
                  .makeMessage(message, chat, context);
              // await FirebaseFirestore.instance
              //     .collection('users')
              //     .doc(widget.currentId)
              //     .collection('messages')
              //     .doc(widget.friendId)
              //     .collection('chats')
              //     .add({
              //   "senderId": widget.currentId,
              //   "receiverId": widget.friendId,
              //   "message": message,
              //   "type": "text",
              //   "date": DateTime.now(),
              // }).then((value) {
              //   FirebaseFirestore.instance
              //       .collection('users')
              //       .doc(widget.currentId)
              //       .collection('messages')
              //       .doc(widget.friendId)
              //       .set({'last_msg': message, "receiverId": widget.friendId});
              // });

              // await FirebaseFirestore.instance
              //     .collection('users')
              //     .doc(widget.friendId)
              //     .collection('messages')
              //     .doc(widget.currentId)
              //     .collection("chats")
              //     .add({
              //   "senderId": widget.currentId,
              //   "receiverId": widget.friendId,
              //   "message": message,
              //   "type": "text",
              //   "date": DateTime.now(),
              // }).then((value) {
              //   FirebaseFirestore.instance
              //       .collection('users')
              //       .doc(widget.friendId)
              //       .collection('messages')
              //       .doc(widget.currentId)
              //       .set({"last_msg": message, "senderId": widget.currentId});
              // });
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: tabColor,
              ),
              child: Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
