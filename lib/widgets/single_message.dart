import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/common/colors.dart';

class SingleMessage extends StatelessWidget {
  final String message;
  final bool isMe;
  final DateTime date;
  SingleMessage(
      {required this.message, required this.isMe, required this.date});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.all(16),
                constraints: BoxConstraints(maxWidth: 200),
                decoration: BoxDecoration(
                    color: isMe ? senderMessageColor : messageColor,
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: Text(
                  message,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )),
            Text(
              DateFormat().add_jms().format(date),
              style: TextStyle(
                color: textColor,
              ),
            )
          ],
        ),
      ],
    );
  }
}
