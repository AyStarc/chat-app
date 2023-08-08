import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

FirebaseAuth fire = FirebaseAuth.instance;

class MsgBubble extends StatefulWidget {
  MsgBubble(this.doc, this.senderID, {Key? key}) : super(key: key);
  QueryDocumentSnapshot<Map<String, dynamic>> doc;
  final String senderID;

  @override
  State<MsgBubble> createState() => _MsgBubbleState();
}

class _MsgBubbleState extends State<MsgBubble> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      child: Container(
        color: Colors.lightGreenAccent,
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
        child: GestureDetector(
          child: Column(
              crossAxisAlignment: (widget.senderID == fire.currentUser!.uid
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start),
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    widget.doc["text"],
                    /* textAlign: (widget.senderID == fire.currentUser!.uid
                    ? TextAlign.right // why didn't work!!!
                    : TextAlign.left),*/
                  ),
                ),
                Row(
                    //children: [Icon(Icons.check_box), Text(widget.doc["createdAt"].toString())],
                    )
              ]),
          onLongPress: () {},
        ),
      ),
    );
  }
}

// Online status of user
