import 'package:flutter/material.dart';
import 'firstpage.dart';
import 'loginscreen.dart';
import 'registrationscreen_doc.dart';
import 'mainscreen_pat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        'loginscreen': (context) => Loginscreen(),
      },
      theme: ThemeData.light(),
      home: Firstpage(),
    );
  }
}
