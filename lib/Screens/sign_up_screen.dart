import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:chat_app/Widgets/user_image_picker.dart';

final firebase = FirebaseAuth.instance;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final form = GlobalKey<FormState>();
  var enteredUsername = '';
  var enteredEmail = '';
  var enteredPassword = '';

  File? selectedImage;
  bool isAuthenticating = false;

  void signup() async {
    setState(() {
      isAuthenticating = true;
    });
    final isValid =
        form.currentState!.validate(); // check currentState not null

    if (!isValid) {
      return;
    }

    form.currentState!.save(); // triggers onSaved in Form sub-widgets.

    if (selectedImage == null) {
      return;
    }

    try {
      final userCredentials = await firebase.createUserWithEmailAndPassword(
          email: enteredEmail, password: enteredPassword);

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child('${userCredentials.user!.uid}.jpg');

      await storageRef.putFile(selectedImage!);
      final imageURL = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredentials.user!.uid)
          .set({
        'username': enteredUsername,
        'email': enteredEmail,
        'image_url': imageURL, //selectedImage
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account Successfully Created")));

      firebase.signInWithEmailAndPassword(
          email: enteredEmail, password: enteredPassword);
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.message!)));
    }

    setState(() {
      isAuthenticating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              UserImagePicker((pickedImage) {
                selectedImage = pickedImage;
              }),
              Card(
                margin: const EdgeInsets.all(12),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Form(
                      key: form,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                                icon: Icon(Icons.mail),
                                label: Text("Username")),
                            autocorrect: false,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  value.trim().length < 4) {
                                return 'Min Username length should be 4';
                              }
                              return null;
                            },
                            onSaved: (val) {
                              enteredUsername = val!;
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                                icon: Icon(Icons.mail),
                                label: Text("Email Address")),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter Email address';
                              }
                              return null;
                            },
                            onSaved: (val) {
                              enteredEmail = val!;
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                                label: Text("Password"), icon: Icon(Icons.key)),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return 'Min password length should be 6';
                              }
                              return null;
                            },
                            onSaved: (val) {
                              enteredPassword = val!;
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          TextButton(
                            onPressed: signup,
                            child: const Text("Create account"),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
