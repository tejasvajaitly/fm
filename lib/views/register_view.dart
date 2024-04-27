import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fm/constants/routes.dart';
import 'package:fm/firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  String _errorMessage = '';

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register your accout')),
      body: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Column(
                  children: [
                    TextField(
                      controller: _email,
                      autocorrect: false,
                      enableSuggestions: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          hintText: 'Enter your email here...'),
                    ),
                    TextField(
                      controller: _password,
                      obscureText: true,
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: const InputDecoration(
                          hintText: 'Enter your password here...'),
                    ),
                    TextButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                        try {
                          final userCredential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: email, password: password);
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              verifyRoute, (route) => false);
                        } on FirebaseAuthException catch (e) {
                          if (e.code == "weak-password") {
                            setState(() {
                              _errorMessage =
                                  "that's a weak password, try with a stronger passwor";
                            });
                          } else if (e.code == 'email-already-in-use') {
                            setState(() {
                              _errorMessage = "this email is already in use";
                            });
                          } else if (e.code == 'invalid-email') {
                            setState(() {
                              _errorMessage = "the email format is invalid";
                            });
                          } else {
                            setState(() {
                              _errorMessage = "something went wrong!";
                            });
                          }
                        }
                      },
                      child: const Text('create account'),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              loginRoute, (route) => false);
                        },
                        child: Column(
                          children: [
                            Text('already registered ? login here'),
                            Text(
                              _errorMessage,
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ))
                  ],
                );

              default:
                return const Text('Loading');
            }
          }),
    );
  }
}
