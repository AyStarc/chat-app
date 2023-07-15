// lists all the chats

// Accessing all docs in a collection
// QuerySnapshot is collection snapshot
// QuerySnapshot snapshot = FirebaseFirestore.instance.collection("users").get() as QuerySnapshot<Object?>;
// snapshot.length;
// snapshot.docs gives all the docs
// snapshot.docs.data() gives the map

// Accessing a doc by its ID
// DocumentSnapshot snapshot = FirebaseFirestore.instance.collection("users").doc("ID of the doc").get();
// snapshot.data() gives the map

// Similarly there are two different ways for uploading data as well.
// With collection.add(...);
// With doc("id").set(...);

import 'package:chat_app/Screens/auth.dart';
import 'package:chat_app/Screens/search_screen.dart';
import 'package:chat_app/Widgets/chat_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

FirebaseFirestore fire = FirebaseFirestore.instance;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final currentUserAuth = firebase.currentUser!;
  final currentUserId = firebase.currentUser!.uid; // currentUser!.uid;
  String curUser = '';

  // How and why?
  void currentUserData() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(currentUserId)
        .get();

    setState(() {
      curUser = snapshot.data()!["username"];
    });
  }

  @override
  void initState() {
    super.initState();
    currentUserData();
  }
// will display all chats for this user.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (ctx) {
              return const SearchScreen();
            }));
          },
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: AppBar(
          backgroundColor: Theme.of(context).splashColor,
          title: Text("Hi! $curUser"), // not null ensured by streamBuilder
          actions: [
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: const Icon(Icons.exit_to_app_outlined))
          ],
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(currentUserId)
              .collection('friends')
              .snapshots(),
          builder: (ctx, snaps) {
            if (snaps.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snaps.hasData || snaps.data == null) {
              return const Center(
                child: Text("No conversations yet! Add friends!"),
              );
            }

            return ListView.builder(
              itemBuilder: (ctx, indx) {
                return ChatTile(
                  id: snaps.data!.docs[indx].id,
                );
              },
              itemCount: snaps.data!.docs.length,
            );
          },
        ));
  }
}
