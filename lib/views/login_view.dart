import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fm/constants/routes.dart';
import 'package:fm/firebase_options.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
      appBar: AppBar(title: const Text('login')),
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
                              .signInWithEmailAndPassword(
                                  email: email, password: password);
                          print(userCredential);
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              mainappRoute, (route) => false);
                        } on FirebaseAuthException catch (e) {
                          if (e.code == "user-not-found") {
                            print('user not found');
                          } else if (e.code == "invalid-credential") {
                            print(e.code);
                            setState(() {
                              _errorMessage = 'something went wrong';
                            });
                          } else {
                            setState(() {
                              _errorMessage = 'something went wrong';
                            });
                          }
                        }
                      },
                      child: const Text('login'),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              registerRoute, (route) => false);
                        },
                        child: Column(
                          children: [
                            Text('not registered ? register here'),
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
