// For a single new message
import 'package:chat_app/Screens/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage(this.id, {Key? key}) : super(key: key);

  final String id;
  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var messageController = TextEditingController();

  String getConvoID(String senderID, String receiverID) {
    if (senderID.hashCode <= receiverID.hashCode) {
      return "${senderID}_$receiverID";
    } else {
      return "${receiverID}_$senderID";
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  void submitMessage() async {
    final enteredMessage = messageController.text;

    if (enteredMessage.trim().isEmpty) {
      return;
    }

    final user = firebase.currentUser!; // from FirebaseAuth

    // final senderData =
    //     await FirebaseFirestore.instance // from FirebaseFirestore
    //         .collection('users')
    //         .doc(user.uid)
    //         .get();
    //
    // final receiverData = await FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(widget.id)
    //     .get();

    // await FirebaseFirestore.instance
    //     .collection('chat')
    //     .doc("${user.uid}_${widget.id}")
    //     .set({
    //   "sender": senderData["username"],
    //   "receiver": receiverData["username"],
    //   "senderImg": senderData["image_url"],
    //   "receiverImg": receiverData["image_url"]
    // });

    await FirebaseFirestore.instance
        .collection('chat')
        .doc(getConvoID(user.uid, widget.id))
        .collection(getConvoID(user.uid, widget.id))
        .doc("${user.uid}_${Timestamp.now()}")
        .set({
      'text': enteredMessage,
      'createdAt': Timestamp.now(),
    });
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: messageController,
            decoration: const InputDecoration(hintText: "Send a message..."),
          ),
        ),
        IconButton(onPressed: submitMessage, icon: const Icon(Icons.send))
      ],
    );
  }
}
