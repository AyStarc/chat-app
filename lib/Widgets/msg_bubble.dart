import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

FirebaseAuth fire = FirebaseAuth.instance;

class MsgBubble extends StatefulWidget {
  const MsgBubble(this.text, this.senderID, {Key? key}) : super(key: key);
  final String text;
  final String senderID;

  @override
  State<MsgBubble> createState() => _MsgBubbleState();
}

class _MsgBubbleState extends State<MsgBubble> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: GestureDetector(
        child: Text(
          widget.text,
          textAlign: (widget.senderID == fire.currentUser!.uid
              ? TextAlign.right
              : TextAlign.left),
        ),
        onLongPress: () {},
      ),
    );
  }
}
