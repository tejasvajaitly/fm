import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fm/constants/routes.dart';
import 'package:fm/views/login_view.dart';
import 'package:fm/vision_detector_views/label_detector_view.dart';

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _logout(BuildContext context) async {
    await _auth.signOut();
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => const LoginView()),
    // );
    Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          actions: [
            TextButton(
              child: const Text('logout'),
              onPressed: () => _logout(context),
            ),
          ],
        ),
        body: ImageLabelView());
  }
}
