//new prescription
import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';

enum Repeat { everyday, alternate, specific }

enum whentoake { afterfood, beforefood }

class PrescriptionScreen extends StatefulWidget {
  static String id = 'new_prescription';
  const PrescriptionScreen({super.key});

  @override
  State<PrescriptionScreen> createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  final _auth = FirebaseAuth.instance;
  late User loggedin;
  @override
  void initState() {
    super.initState();
    getcurrentuser();
  }

  void getcurrentuser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedin = user;
        print(loggedin.email);
      }
    } catch (e) {
      print(e);
    }
  }

  TextEditingController namecontroller = new TextEditingController();

  String prescriptionName = "";
  Repeat selectedrepeat = Repeat.everyday;
  whentoake selectedtaken = whentoake.afterfood;
  int tabletcount = 1;
  int daycount = 1;
  Color morning = activecolor;
  Color noon = inactivecolor;
  Color evening = inactivecolor;
  Color night = inactivecolor;
  List time = ['Morning'];
  String repeating = 'everyday';
  String tobetaken = 'after food.';

  @override
  Widget build(BuildContext context) {
    //Addcard adding = Get.put(Addcard());
    String temp = time.join(', ');
    String description =
        '$tabletcount tablet $repeating for $daycount days in $temp $tobetaken';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MY PRESCRIPTION',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.centerRight,
                colors: <Color>[kprimColor, activecolor]),
            //gradient: LinearGradient(colors: [kprimColor, activecolor])
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 70,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.centerRight,
                    colors: <Color>[kprimColor, activecolor]),
                //gradient: LinearGradient(colors: [kprimColor, activecolor])
              ),
              child: Center(
                  child: Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              )),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: namecontroller,
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
                onChanged: (value) {
                  prescriptionName = value;
                },
                decoration: kinputdecor.copyWith(
                  hintText: 'Enter prescription name',
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            //1st row
            Row(
              children: <Widget>[
                //Card 1
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Dosage'),
                        SizedBox(
                          height: 10,
                        ),

                        //Action buttons////
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FloatingActionButton.small(
                              onPressed: () {
                                setState(() {
                                  if (tabletcount > 1) {
                                    tabletcount--;
                                    print(description);
                                  }
                                });
                              },
                              child: removeicon,
                              shape: CircleBorder(),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('$tabletcount Tablet'),
                            SizedBox(
                              width: 10,
                            ),
                            FloatingActionButton.small(
                              onPressed: () {
                                setState(() {
                                  tabletcount++;
                                });
                              },
                              child: addicon,
                              shape: CircleBorder(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                //Card 2
                Expanded(
                    child: Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Duration Days'),
                      SizedBox(
                        height: 10,
                      ),
                      //Action buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FloatingActionButton.small(
                            onPressed: () {
                              setState(() {
                                if (daycount > 1) {
                                  daycount--;
                                }
                              });
                            },
                            child: removeicon,
                            shape: CircleBorder(),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text('$daycount Days'),
                          SizedBox(
                            width: 10,
                          ),
                          FloatingActionButton.small(
                            onPressed: () {
                              setState(() {
                                daycount++;
                              });
                            },
                            child: addicon,
                            shape: CircleBorder(),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
              ],
            ),
            //Row 1 end
            SizedBox(
              height: 15,
            ),
            //Row 2
            Container(
              margin: EdgeInsets.only(left: 30, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 4, bottom: 10, top: 10),
                    child: Text('Repeat'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedrepeat = Repeat.everyday;
                              repeating = 'everyday';
                            });
                          },
                          child: Container(
                            //margin: buttonmargin,
                            padding: pad,
                            child: Text('Everyday'),
                            decoration: BoxDecoration(
                              color: selectedrepeat == Repeat.everyday
                                  ? activecolor
                                  : inactivecolor,
                              borderRadius: BorderRadius.circular(borderradius),
                            ),
                          )),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedrepeat = Repeat.alternate;
                              repeating = 'alternate days';
                            });
                          },
                          child: Container(
                            //margin: buttonmargin,
                            padding: pad,
                            child: Text('Alternate Days'),
                            decoration: BoxDecoration(
                              color: selectedrepeat == Repeat.alternate
                                  ? activecolor
                                  : inactivecolor,
                              borderRadius: BorderRadius.circular(borderradius),
                            ),
                          )),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedrepeat = Repeat.specific;
                            repeating = 'specific days';
                          });
                        },
                        child: Container(
                          padding: pad,
                          child: Text('Specific Days'),
                          decoration: BoxDecoration(
                            color: selectedrepeat == Repeat.specific
                                ? activecolor
                                : inactivecolor,
                            borderRadius: BorderRadius.circular(borderradius),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            //Row 3
            Container(
              margin: EdgeInsets.only(left: 30, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 4, bottom: 10, top: 10),
                    child: Text('Time of the Day'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              morning == inactivecolor
                                  ? {morning = activecolor, time.add('Morning')}
                                  : {
                                      morning = inactivecolor,
                                      time.remove('Morning')
                                    };
                            });
                          },
                          child: Container(
                            //margin: buttonmargin,
                            padding: pad,
                            child: Text('Morning'),
                            decoration: BoxDecoration(
                              color: morning,
                              borderRadius: BorderRadius.circular(borderradius),
                            ),
                          )),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              noon == inactivecolor
                                  ? {noon = activecolor, time.add('noon')}
                                  : {noon = inactivecolor, time.remove('noon')};
                            });
                          },
                          child: Container(
                            //margin: buttonmargin,
                            padding: pad,
                            child: Text('Noon'),
                            decoration: BoxDecoration(
                              color: noon,
                              borderRadius: BorderRadius.circular(borderradius),
                            ),
                          )),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            evening == inactivecolor
                                ? {evening = activecolor, time.add('evening')}
                                : {
                                    evening = inactivecolor,
                                    time.remove('evening')
                                  };
                          });
                        },
                        child: Container(
                          //margin: buttonmargin,
                          padding: pad,
                          child: Text('Evening'),
                          decoration: BoxDecoration(
                            color: evening,
                            borderRadius: BorderRadius.circular(borderradius),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            night == inactivecolor
                                ? {night = activecolor, time.add('night')}
                                : {night = inactivecolor, time.remove('night')};
                          });
                        },
                        child: Container(
                          padding: pad,
                          child: Text('Night'),
                          decoration: BoxDecoration(
                            color: night,
                            borderRadius: BorderRadius.circular(borderradius),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            //Row 4
            Container(
              margin: EdgeInsets.only(left: 30, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 4, bottom: 10, top: 10),
                    child: Text('To be taken'),
                  ),
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedtaken = whentoake.afterfood;
                            tobetaken = 'after food.';
                          });
                        },
                        child: Container(
                          margin: buttonmargin,
                          padding: pad,
                          child: Text('After food'),
                          decoration: BoxDecoration(
                            color: selectedtaken == whentoake.afterfood
                                ? activecolor
                                : inactivecolor,
                            borderRadius: BorderRadius.circular(borderradius),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedtaken = whentoake.beforefood;
                            tobetaken = 'before food.';
                          });
                        },
                        child: Container(
                          padding: pad,
                          child: Text('Before food'),
                          decoration: BoxDecoration(
                            color: selectedtaken == whentoake.beforefood
                                ? activecolor
                                : inactivecolor,
                            borderRadius: BorderRadius.circular(borderradius),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            //End button//////////////////////////////////////////////////////
            Container(
              margin: EdgeInsets.only(bottom: 20),
              padding: pad,
              decoration: BoxDecoration(
                color: kprimColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () async {
                  String id = randomAlphaNumeric(15);
                  setState(() async {
                    if (prescriptionName.isNotEmpty) {
                      Map<String, dynamic> prescriptioninfo = {
                        "email": loggedin.email,
                        "id": id,
                        "Name": prescriptionName,
                        "Repeating": repeating,
                        "Tablet count": tabletcount.toString(),
                        "Day count": daycount.toString(),
                        "To be taken": tobetaken
                      };
                      await DatabaseMethods().addPrescriptionDetails(
                          prescriptioninfo, id); // unique id
                      // adding.add(prescriptionName, repeating,
                      //     tabletcount.toString(), daycount.toString(), tobetaken);
                      print('updated');
                      Navigator.pop(context); // Close the current screen
                    } else {
                      // Show dialog if prescription name is empty
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Prescription Name Empty'),
                          content:
                              const Text('Please provide a prescription name.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  });
                },
                child: Text(
                  'Add prescription',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
      //Column end
    );
  }
}

class DatabaseMethods {
  Future addPrescriptionDetails(
      Map<String, dynamic> prescriptioninfo, String id) async {
    return await FirebaseFirestore.instance
        .collection('Prescriptions')
        .doc(id)
        .set(prescriptioninfo);
  }

  Future<Stream<QuerySnapshot>> getPrescriptionDetails() async {
    return await FirebaseFirestore.instance
        .collection('Prescriptions')
        .snapshots();
  }

  Future deletePrescriptions(String id) async {
    return await FirebaseFirestore.instance
        .collection('Prescriptions')
        .doc(id)
        .delete();
  }
}
