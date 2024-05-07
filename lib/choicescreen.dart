import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medilocker/registrationscreen_doc.dart';
import 'package:medilocker/registrationscreen_pat.dart';
import 'constants.dart';
import 'mainscreen_pat.dart';

enum Profession {
  doctor,
  patient,
}

class Choicescreen extends StatefulWidget {
  const Choicescreen({super.key});

  @override
  State<Choicescreen> createState() => _ChoicescreenState();
}

class _ChoicescreenState extends State<Choicescreen> {
  Profession? selectedpath;
  String typeofaccount = 'User!';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        SizedBox(
          height: 100,
        ),
        Hero(
          tag: 'logo',
          child: Image(
            height: 150,
            image: AssetImage('images/translogo.png'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            'Choose Account Type',
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
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Registrationscreen_doc(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selectedpath == Profession.doctor
                            ? Color(0xFF013E36)
                            : Colors.white,
                        width: 2.5,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image(
                        height: 150,
                        image: AssetImage('images/doc.jpg'),
                      ),
                    ),
                  ),
                ),
                Text(
                  'DOCTOR',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF014037),
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Registrationscreen_pat(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selectedpath == Profession.patient
                            ? Color(0xFF013E36)
                            : Colors.white,
                        width: 2.5,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image(
                        height: 150,
                        image: AssetImage('images/pat.jpg'),
                      ),
                    ),
                  ),
                ),
                Text(
                  'PATIENT',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF014037),
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ],
        ),
      ]),
    );
  }
}
