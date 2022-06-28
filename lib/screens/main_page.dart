import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  // MainPage({this.userEmail});

  final String email="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(email),
        ),
        body: Container(
          child: TextButton(onPressed: () {
            FirebaseAuth.instance.signOut();
          }, child: const Text("Logout")),
        ));
  }
}
