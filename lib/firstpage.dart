import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:medilocker/choicescreen.dart';
import 'package:medilocker/registrationscreen_pat.dart';
import 'loginscreen.dart';

class Firstpage extends StatefulWidget {
  const Firstpage({super.key});

  @override
  State<Firstpage> createState() => _FirstpageState();
}

class _FirstpageState extends State<Firstpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Hero(
          tag: 'logo',
          child: Image(
            height: 100,
            image: AssetImage('images/translogo.png'),
          ),
        ),
        SizedBox(
          height: 50,
        ),
        Text(
          textAlign: TextAlign.center,
          'MEDILOCKER',
          style: TextStyle(
            color: Color(0xFF014037),
            fontSize: 30,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              textAlign: TextAlign.center,
              'A vault\nfor all your medical needs.',
              textStyle: TextStyle(
                color: Color(0xFF014037),
                fontSize: 23,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          totalRepeatCount: 1,
        ),
        SizedBox(
          height: 50,
        ),
        login(
          text: 'LOG IN',
          Onpressed: () {
            Navigator.pushNamed(context, 'loginscreen');
          },
        ),
        SizedBox(
          height: 50,
        ),
        login(
          text: 'REGISTER NOW',
          Onpressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Choicescreen(),
              ),
            );
          },
        ),
      ],
    ));
  }
}

class login extends StatelessWidget {
  login({required this.Onpressed, required this.text});
  Function Onpressed;
  String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 40),
      child: Container(
        height: 60,
        child: Material(
          elevation: 5.0,
          color: Color(0xFF02B272),
          borderRadius: BorderRadius.circular(30.0),
          child: MaterialButton(
            onPressed: () {
              Onpressed();
            },
            minWidth: 200.0,
            height: 42.0,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
