import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final form = GlobalKey<FormState>(); // key to the form
  var enteredEmail = '';
  var enteredPassword = '';

  void submit() {
    final isValid =
        form.currentState!.validate(); // check currentState not null

    if (!isValid) {
      return;
    }

    form.currentState!.save(); // triggers onSaved in Form sub-widgets.
  }

  void signup() async {
    final isValid =
        form.currentState!.validate(); // check currentState not null

    if (!isValid) {
      return;
    }

    form.currentState!.save(); // triggers onSaved in Form sub-widgets.

    try {
      final userCredentials = await firebase.createUserWithEmailAndPassword(
          email: enteredEmail, password: enteredPassword);
      print(UserCredential);
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.message!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(40),
                alignment: Alignment.center,
                child: Image.asset("Assets/Images/pngwing.com (1).png"),
              ),
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
                                label: Text("Email Address")),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter valid Email address';
                              }
                              return null;
                            },
                            onSaved: (val) {
                              enteredEmail = val!;
                            },
                          ),
                          TextFormField(
                            decoration:
                                const InputDecoration(label: Text("Password")),
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
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer),
                              onPressed: submit,
                              child: const Text("Login")),
                          TextButton(
                            onPressed: () {},
                            child: const Text("Create a new account"),
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
