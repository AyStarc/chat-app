import 'dart:math';

import 'package:chat_app/Screens/chats_list_screeen.dart';
import 'package:chat_app/Widgets/chat_messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchValue = '';
  Map<String, String> map = {};

  Future<void> suggestFunc() async {
    final sgsn = await FirebaseFirestore.instance.collection('users').get();
    for (var element in sgsn.docs) {
      map.addAll({element["username"].toString(): element.id});
    }
  }

  void addUser(String name) async {
    final user = FirebaseAuth.instance.currentUser!; // from FirebaseAuth

    final senderData =
        await FirebaseFirestore.instance // from FirebaseFirestore
            .collection('users')
            .doc(user.uid)
            .get();

    final receiverData = await FirebaseFirestore.instance
        .collection('users')
        .doc(map[name])
        .get();

    await FirebaseFirestore.instance
        .collection('chat')
        .doc("${user.uid}_${map[name]!}")
        .set({
      "sender": senderData.data()!["username"],
      "receiver": name,
      "senderImg": senderData.data()!["image_url"],
      "receiverImg": receiverData.data()!["image_url"]
    });

    // can add last msg, last msg sender, timestamp in this as well

    FirebaseFirestore.instance
        .collection('users')
        .doc(map[name])
        .collection('friends')
        .doc(user.uid)
        .set({});

    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('friends')
        .doc(map[name])
        .set({});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    suggestFunc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: EasySearchBar(
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Theme.of(context).canvasColor,
      title: const Text('Example'),
      onSearch: (value) => setState(() => searchValue = value),
      suggestions: map.keys.toList(),
      onSuggestionTap: (val) {
        addUser(val);
        Navigator.pop(context, MaterialPageRoute(builder: (ctx) {
          return const ChatMessages();
        }));
      },
    ));
  }
}
