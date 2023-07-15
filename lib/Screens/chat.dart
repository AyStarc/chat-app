import 'package:chat_app/Widgets/new_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

FirebaseFirestore fire = FirebaseFirestore.instance;

class ChatOneToOne extends StatefulWidget {
  const ChatOneToOne(this.id, {Key? key}) : super(key: key);
  final String id;

  @override
  State<ChatOneToOne> createState() => _ChatOneToOneState();
}

class _ChatOneToOneState extends State<ChatOneToOne> {
  String receiver = '';
  String imageurl = '';

  // How and why?
  getUserDetails(String uid) async {
    var temp = await fire.collection('users').doc(uid).get();

    setState(() {
      receiver = temp.data()!["username"];
      imageurl = temp.data()!["image_url"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TO text"),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            child: ListView.builder(itemBuilder: )
          ),
          const NewMessage("dd")
        ],
      ),
    );
  }
}
