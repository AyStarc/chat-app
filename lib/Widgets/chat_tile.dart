import 'package:chat_app/Screens/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

FirebaseFirestore fire = FirebaseFirestore.instance;

class ChatTile extends StatefulWidget {
  const ChatTile({Key? key, required this.id}) : super(key: key);

  final String id;
  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  String str = '';
  String imageurl = '';

  // How and why?
  getUserDetails(String uid) async {
    var temp = await fire.collection('users').doc(uid).get();

    setState(() {
      str = temp.data()!["username"];
      imageurl = temp.data()!["image_url"];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ChatOneToOne(widget.id)));
      },
      child: ListTile(
        leading: CircleAvatar(
          child: Image.network(
            imageurl,
            fit: BoxFit.contain,
          ),
        ),
        title: Text(str),
      ),
    );
  }
}
