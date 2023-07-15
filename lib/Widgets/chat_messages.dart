// Messages between users one to one
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('chats').snapshots(),
        builder: (ctx, chatSnapshots) {
          if (chatSnapshots.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // why using this expression
          // second expression in OR only evaluated if first false.
          if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
            return const Center(
              child: Text("Break the ice!"),
            );
          }

          if (chatSnapshots.hasError) {
            return const Center(
              child: Text("Something went wrong."),
            );
          } else {
            return const Text("data");
          }
        });
  }
}
