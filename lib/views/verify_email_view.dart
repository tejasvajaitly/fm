import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('verify email')),
      body: Column(
        children: [
          Text('please verufy your email address'),
          TextButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                user?.sendEmailVerification();
                await FirebaseAuth.instance.signOut();
              },
              child: Text('send email virification'))
        ],
      ),
    );
  }
}
