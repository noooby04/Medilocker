import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medilocker/mainscreen_pat.dart';
import 'Reminder.dart';
import 'profile_page.dart';
import 'homepage.dart';
import 'allprescription.dart';
import 'Reminder.dart';

class Mainscreen_pat extends StatefulWidget {
  const Mainscreen_pat({super.key});

  @override
  State<Mainscreen_pat> createState() => _Mainscreen_patState();
}

class _Mainscreen_patState extends State<Mainscreen_pat> {
  int currentindex = 1;
  Color color = Colors.black;
  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      ReminderScreen(),
      Homepage(),
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
                Icons.alarm_sharp,
                color: currentindex == 0 ? Color(0xFF00BE78) : Colors.black,
              ),
              label: 'Reminder'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: currentindex == 1 ? Color(0xFF00BE78) : Colors.black,
              ),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.file_copy,
                color: currentindex == 2 ? Color(0xFF00BE78) : Colors.black,
              ),
              label: 'Prescriptions'),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle_rounded,
              color: currentindex == 3 ? Color(0xFF00BE78) : Colors.black,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
