import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medilocker/mainscreen_doc.dart';
import 'package:medilocker/registrationscreen_doc.dart';
import 'constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'mainscreen_pat.dart';

enum Profession {
  doctor,
  patient,
}

class Registrationscreen_doc extends StatefulWidget {
  const Registrationscreen_doc({super.key});

  @override
  State<Registrationscreen_doc> createState() => _Registrationscreen_docState();
}

class _Registrationscreen_docState extends State<Registrationscreen_doc> {
  Profession? selectedpath;
  String typeofaccount = 'User!';

  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  int phoneno = 0;
  String firstname = '';
  String lastname = '';
  int age = 0;
  String gender = '';
  String physical = 'none';
  String medical = 'none';
  String regno = '';

  Future SignUp() async {
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (newUser != null) {
        AddUserDetails(firstname, lastname, age, gender, physical, medical,
            phoneno, email, regno);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Mainscreen_doc(),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future AddUserDetails(
      String firstname,
      String lastname,
      int age,
      String gender,
      String physical,
      String medical,
      int phoneno,
      String email,
      String regno) async {
    /*await FirebaseFirestore.instance.collection("details").add({
      'firstname': firstname,
      'lastname': lastname,
      'age': age,
      'gender': gender,
      'physical': physical,
      'medical': medical,
      'phoneno': phoneno,
      'email': email,
      'regno': regno,
    });*/
    await FirebaseFirestore.instance.collection("details").doc(email).set({
      'firstname': firstname,
      'lastname': lastname,
      'age': age,
      'gender': gender,
      'physical': physical,
      'medical': medical,
      'phoneno': phoneno,
      'email': email,
      'regno': regno,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                'DOCTOR REGISTRATION',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF014037),
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFF013E36),
                      width: 2.5,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Hero(
                      tag: 'logo',
                      child: Image(
                        height: 200,
                        image: AssetImage('images/doc.jpg'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                'Hello Doctor!\nPlease fill out the form below to get started',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF014037),
                  fontSize: 15,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
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
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
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
                    Icons.password_sharp,
                    size: 26,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
                onChanged: (value) {
                  phoneno = int.parse(value);
                },
                decoration: kinputdecor.copyWith(
                  hintText: 'Enter your phone number',
                  prefixIcon: Icon(
                    Icons.phone,
                    size: 26,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
                onChanged: (value) {
                  firstname = value;
                },
                decoration: kinputdecor.copyWith(
                  hintText: 'Enter your first name',
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
                onChanged: (value) {
                  lastname = value;
                },
                decoration: kinputdecor.copyWith(
                  hintText: 'Enter your last name',
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
                onChanged: (value) {
                  age = int.parse(value);
                },
                decoration: kinputdecor.copyWith(
                  hintText: 'Enter your age',
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
                onChanged: (value) {
                  gender = value;
                },
                decoration: kinputdecor.copyWith(
                  hintText: 'Enter your gender',
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
                onChanged: (value) {
                  regno = value;
                },
                decoration: kinputdecor.copyWith(
                  hintText: 'Enter registration number',
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: ElevatedButton(
                onPressed: () {
                  SignUp();
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
                    'REGISTER NOW',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 60,
            ),
          ],
        ),
      ),
    );
  }
}
