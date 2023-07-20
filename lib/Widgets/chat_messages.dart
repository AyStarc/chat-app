// Messages between users one to one

import 'dart:developer';

import 'package:chat_app/Widgets/msg_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

FirebaseFirestore fire = FirebaseFirestore.instance;

class ChatMessages extends StatelessWidget {
  const ChatMessages(this.chatid, {Key? key}) : super(key: key);
  final String chatid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .doc("${FirebaseAuth.instance.currentUser!.uid}_$chatid")
            .collection("${FirebaseAuth.instance.currentUser!.uid}_$chatid")
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
                debugPrint(chatSnapshots.data!.docs[indx]["text"]);
                return MsgBubble(chatSnapshots.data!.docs[indx]["text"],
                    FirebaseAuth.instance.currentUser!.uid);
              },
              itemCount: chatSnapshots.data!.docs.length,
            );
          }
        });
  }
}
