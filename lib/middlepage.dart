/*
import 'package:flutter/material.dart';
import 'package:medilocker/firstpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'homepage.dart';

class Middlepage extends StatefulWidget {
  const Middlepage({super.key});

  @override
  State<Middlepage> createState() => _MiddlepageState();
}

class _MiddlepageState extends State<Middlepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Homepage();
          } else {
            return Homescreen();
          }
        },
      ),
    );
  }
}
*/
