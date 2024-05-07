import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _auth = FirebaseAuth.instance;
late User loggedin;

class Reminder {
  String frequency;
  TimeOfDay selectedTime;
  String remindcontext;
  bool isSwitched;

  Reminder({
    required this.frequency,
    required this.selectedTime,
    required this.remindcontext,
    this.isSwitched = true,
  });
}

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  TimeOfDay selectedTime = TimeOfDay.now();
  bool isSwitched = true;
  Stream? reminderstream;

  void toggleSwitch(bool value /*, int index*/) {
    setState(() {
      isSwitched = value;
    });
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

  getonload() async {
    reminderstream = await ReminderMethods().getReminderDetails();
    setState(() {});
  }

  @override
  void initState() {
    getonload();
    getcurrentuser();
    super.initState();
  }

  Widget alldata() {
    return StreamBuilder(
        stream: reminderstream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    print('${ds.id}');
                    return ds['email'] == loggedin.email
                        ? GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  String newFrequency = 'Edit frequency';
                                  String newContext = 'Edit context';

                                  return AlertDialog(
                                    title: Text(
                                      "Edit Reminder",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          decoration: InputDecoration(
                                              labelText: "Frequency"),
                                          onChanged: (value) {
                                            newFrequency =
                                                value; // Convert to uppercase
                                          },
                                        ),
                                        TextField(
                                          decoration: InputDecoration(
                                              labelText: "Reminder Context"),
                                          onChanged: (value) {
                                            newContext = value;
                                          },
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            ReminderMethods()
                                                .updateReminder(ds.id, {
                                              'frequency': newFrequency,
                                              'remindercontext': newContext,
                                              'hour': ds['hour'],
                                              'min': ds['min'],
                                              'email': ds['email'],
                                              'isswitched': ds['isswitched'],
                                            });
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "Save",
                                          style: TextStyle(
                                              color: Color(0xFF00BE78)),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            ReminderMethods()
                                                .deleteReminders(ds.id);
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "Delete",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          ds['frequency'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.grey[800],
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          '${ds['hour']}:${ds['min']}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24,
                                            color: Color(0xFF00BE78),
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          ds['remindercontext'],
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Switch(
                                      activeColor: Color(0xFF00BE78),
                                      value: ds['isswitched'],
                                      onChanged: (value) {
                                        setState(() {
                                          ReminderMethods()
                                              .updateReminder(ds.id, {
                                            'frequecy': ds['frequency'],
                                            'remindercontext':
                                                ds['remindercontext'],
                                            'hour': ds['hour'],
                                            'min': ds['min'],
                                            'email': loggedin.email,
                                            'isswitched': value,
                                          });
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Container();
                  },
                )
              : Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'My Reminders',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Color(0xFF00BE78),
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final TimeOfDay? timeOfDay = await showTimePicker(
            context: context,
            initialTime: selectedTime,
            initialEntryMode: TimePickerEntryMode.dial,
          );
          if (timeOfDay != null) {
            setState(() {
              selectedTime = timeOfDay;
              ReminderMethods().addReminderDetails({
                'frequency': 'Edit frequency',
                'remindercontext': 'Edit context',
                'hour': selectedTime.hour,
                'min': selectedTime.minute,
                'email': loggedin.email,
                'isswitched': true,
              });
              // addReminder(selectedTime);
            });
          }
        },
        backgroundColor: Color(0xFF00BE78),
        label: Text(
          'Add Reminder',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        icon: Icon(Icons.add),
      ),
      body: Column(children: [Expanded(child: alldata())]),
    );
  }
}

class ReminderMethods {
  Future addReminderDetails(Map<String, dynamic> reminderinfo) async {
    return await FirebaseFirestore.instance
        .collection('Reminders')
        .add(reminderinfo);
  }

  Future<Stream<QuerySnapshot>> getReminderDetails() async {
    return await FirebaseFirestore.instance.collection('Reminders').snapshots();
  }

  Future deleteReminders(String id) async {
    return await FirebaseFirestore.instance
        .collection('Reminders')
        .doc(id)
        .delete();
  }

  Future updateReminder(String id, Map<String, dynamic> reminderinfo) async {
    return await FirebaseFirestore.instance
        .collection('Reminders')
        .doc(id)
        .update(reminderinfo);
  }
}
