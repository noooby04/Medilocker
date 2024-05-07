import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'newprescription.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'newprescription_doc.dart';

class Allprescription extends StatefulWidget {
  const Allprescription({super.key});
  @override
  State<Allprescription> createState() => _AllprescriptionState();
}

class _AllprescriptionState extends State<Allprescription> {
  final _auth = FirebaseAuth.instance;
  late User loggedin;

  void getcurrentuser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedin = user;
      }
    } catch (e) {
      print(e);
    }
  }

  Stream? prescriptionStream;

  getonload() async {
    prescriptionStream = await DatabaseMethods().getPrescriptionDetails();
    setState(() {
      print(prescriptionStream);
    });
  }

  @override
  void initState() {
    getonload();
    getcurrentuser();
    super.initState();
  }

  Widget allData() {
    return StreamBuilder(
        stream: prescriptionStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    //UI//////////////////////////////////////////////////////////
                    return ds.get("email") == loggedin.email
                        ? Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 20),
                                padding: pad,
                                decoration: BoxDecoration(
                                    color: Color(0xFF00BE78),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10)),
                                    border: Border.all(color: Colors.teal)),

                                //text and icon
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(left: 20),
                                      child: Text(
                                        ds["Name"],
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () async {
                                          await DatabaseMethods()
                                              .deletePrescriptions(ds["id"]);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 20.0),
                                          //Close icon
                                          child: Icon(Icons.delete),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              //Inside card 2nd container
                              Container(
                                margin: EdgeInsets.only(left: 20, right: 20),
                                //padding: pad,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                    border: Border.all(color: Colors.teal)),

                                //Row of info
                                child: Material(
                                  borderRadius: BorderRadius.circular(10),
                                  elevation: 10.0,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            decoration: BoxDecoration(
                                                color: activecolor
                                                    .withOpacity(0.3),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            padding: EdgeInsets.all(10),
                                            margin: EdgeInsets.only(left: 15),
                                            child: Text(ds["Repeating"]),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: activecolor
                                                    .withOpacity(0.3),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            padding: EdgeInsets.all(10),
                                            margin: EdgeInsets.only(left: 15),
                                            child: Text(
                                                ds["Tablet count"] + ' tab'),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: activecolor
                                                    .withOpacity(0.3),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            padding: EdgeInsets.all(10),
                                            margin: EdgeInsets.all(15),
                                            child:
                                                Text(ds["Day count"] + ' days'),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: activecolor.withOpacity(0.3),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        padding: EdgeInsets.all(10),
                                        margin: EdgeInsets.only(
                                            left: 10, bottom: 10),
                                        child: Text(ds["To be taken"]),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                        : Container();
                  })
              : Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(
            child: Text(
              'My Prescriptions',
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
        floatingActionButton: FloatingActionButton(
          heroTag: 'floating action button',
          onPressed: () async {
            final userDoc = await FirebaseFirestore.instance
                .collection("details")
                .doc(loggedin.email)
                .get();
            if (userDoc.exists) {
              final regNo = userDoc.get("regno");
              if (regNo == "") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrescriptionScreen(),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrescriptionScreen_doc(),
                  ),
                );
              }
              print("User document does not exist for UID: ${loggedin.uid}");
            }
          },
          child: Icon(Icons.add),
        ),
        body: Column(
          children: <Widget>[
            Expanded(child: allData()),
            SizedBox(
              height: 20,
            )
          ],
        ));
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
