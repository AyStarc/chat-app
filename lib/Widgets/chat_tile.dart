import 'package:chat_app/Screens/chat.dart';
import 'package:flutter/material.dart';

class ChatTile extends StatefulWidget {
  const ChatTile({Key? key}) : super(key: key);

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ChatOneToOne()));
      },
      child: const ListTile(
        leading: CircleAvatar(),
        title: Text("UserName"),
      ),
    );
  }
}
