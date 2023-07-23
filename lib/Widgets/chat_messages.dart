// Messages between users one to one

import 'dart:developer';

import 'package:chat_app/Screens/auth.dart';
import 'package:chat_app/Widgets/msg_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

FirebaseFirestore fire = FirebaseFirestore.instance;

class ChatMessages extends StatelessWidget {
  const ChatMessages(this.receiverID, {Key? key}) : super(key: key);
  final String receiverID;

  checkSenderOrReceiver() {}
  String getConvoID(String senderID, String receiverID) {
    if (senderID.hashCode <= receiverID.hashCode) {
      return "${senderID}_$receiverID";
    } else {
      return "${receiverID}_$senderID";
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .doc(getConvoID(firebase.currentUser!.uid, receiverID))
            .collection(getConvoID(firebase.currentUser!.uid, receiverID))
            .orderBy("createdAt")
            .snapshots(),
        builder: (ctx, chatSnapshots) {
          if (chatSnapshots.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // why using this expression
          // second expression in OR only evaluated if first false.
          if (!chatSnapshots.hasData) {
            return const Center(
              child: Text("Break the ice!"),
            );
          }

          if (chatSnapshots.hasError) {
            return const Center(
              child: Text("Something went wrong."),
            );
          } else {
            return ListView.builder(
              itemBuilder: (ctx, indx) {
                return Container(
                 //  width: 50, // iska effect kyon nhi aa raha
                  alignment: (chatSnapshots.data!.docs[indx].id.split("_")[0] ==
                          receiverID
                      ? Alignment.topLeft
                      : Alignment.topRight),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                    child: MsgBubble(chatSnapshots.data!.docs[indx]["text"],
                        chatSnapshots.data!.docs[indx].id.split("_")[0]),
                  ),
                );
              },
              itemCount: chatSnapshots.data!.docs.length,
            );
          }
        });
  }
}
