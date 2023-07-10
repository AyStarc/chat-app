import 'package:chat_app/Screens/chats_list_screeen.dart';
import 'package:chat_app/Widgets/new_message.dart';
import 'package:chat_app/main.dart';
import 'package:flutter/material.dart';

class ChatOneToOne extends StatefulWidget {
  const ChatOneToOne({Key? key}) : super(key: key);

  @override
  State<ChatOneToOne> createState() => _ChatOneToOneState();
}

class _ChatOneToOneState extends State<ChatOneToOne> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TO text"),

      ),
      body: Column(
        children: [
          SingleChildScrollView(
            child: Container(
              height: 200,
            ),
          ),
          const NewMessage()
        ],
      ),
    );
  }
}
