import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Image.asset("Assets/Images/pngwing.com.png"),
              ),
              Card(
                child: SingleChildScrollView(
                  child:
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Form(
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              label: Text("Email Address")
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                          ),

                          TextFormField(
                            decoration: InputDecoration(
                                label: Text("Password")
                            ),
                            obscureText: true,
                          ),

                        ],
                      ),
                    ),
                  ),
                ),

              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
      ),
    );
  }
}
