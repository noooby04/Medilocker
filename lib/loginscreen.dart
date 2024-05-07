import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medilocker/mainscreen_doc.dart';
import 'package:medilocker/mainscreen_pat.dart';
import 'constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 50),
            Text(
              'LOG IN',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
                color: Color(0xFF014037),
              ),
            ),
            SizedBox(height: 20),
            Hero(
              tag: 'logo',
              child: Image(
                height: 150,
                image: AssetImage('images/translogo.png'),
              ),
            ),
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
                onChanged: (value) {
                  email = value;
                },
                decoration: kinputdecor.copyWith(
                  hintText: 'Enter your email',
                  prefixIcon: Icon(
                    Icons.email,
                    size: 26,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
                onChanged: (value) {
                  password = value;
                },
                decoration: kinputdecor.copyWith(
                  hintText: 'Enter your password',
                  prefixIcon: Icon(
                    Icons.lock,
                    size: 26,
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    final userCredential =
                        await _auth.signInWithEmailAndPassword(
                            email: email, password: password);
                    final user = userCredential.user;
                    if (user != null) {
                      final userDoc = await FirebaseFirestore.instance
                          .collection("details")
                          .doc(user.email)
                          .get();
                      if (userDoc.exists) {
                        final regNo = userDoc.get("regno");
                        if (regNo == "") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Mainscreen_pat(),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Mainscreen_doc(),
                            ),
                          );
                        }
                        print(
                            "User document does not exist for UID: ${user.uid}");
                      }
                    }
                  } catch (e) {
                    print(e);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF02B272),
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'LOG IN',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
