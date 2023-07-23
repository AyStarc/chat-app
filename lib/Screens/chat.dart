import 'package:chat_app/Widgets/chat_messages.dart';
import 'package:chat_app/Widgets/msg_bubble.dart';
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
  String receiverID = '';
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
  void initState() {
    // TODO: implement initState
    super.initState();
    receiverID = widget.id;
    getUserDetails(receiverID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [CircleAvatar(child: Image.network(imageurl))],
          title: Text(receiver),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(child: ChatMessages(receiverID)),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: NewMessage(widget.id))
            ],
          ),
        ));
  }
}
