import 'package:flutter/material.dart';

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
    return GestureDetector(
      child: Text(widget.text),
      onLongPress: () {},
    );
  }
}
