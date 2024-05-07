import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medilocker/mainscreen_pat.dart';
import 'Reminder.dart';
import 'profile_page.dart';
import 'homepage.dart';
import 'allprescription.dart';

class Mainscreen_doc extends StatefulWidget {
  const Mainscreen_doc({super.key});

  @override
  State<Mainscreen_doc> createState() => _Mainscreen_docState();
}

class _Mainscreen_docState extends State<Mainscreen_doc> {
  int currentindex = 1;
  Color color = Colors.black;
  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      Allprescription(),
      Profilepage(),
    ];
    return Scaffold(
      body: screens[currentindex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            currentindex = value;
          });
        },
        currentIndex: currentindex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF00BE78),
        selectedFontSize: 15,
        unselectedFontSize: 12,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.file_copy,
                color: currentindex == 0 ? Color(0xFF00BE78) : Colors.black,
              ),
              label: 'Prescriptions'),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle_rounded,
              color: currentindex == 1 ? Color(0xFF00BE78) : Colors.black,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
