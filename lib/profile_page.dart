import 'dart:typed_data';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:medilocker/firstpage.dart';
import 'package:image_picker/image_picker.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  final _auth = FirebaseAuth.instance;
  late User loggedinInUser;
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedinInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  getontheload() async {
    UserDetailsStream = await getUserDetails();
    setState(() {});
  }

  @override
  void initState() {
    getCurrentUser();
    getontheload();
    fetchProfileImage();
    super.initState();
  }

  Future<Stream<QuerySnapshot>> getUserDetails() async {
    return await FirebaseFirestore.instance.collection("details").snapshots();
  }

  Stream? UserDetailsStream;

  // Image variable
  String? profileImageUrl;

  // Method to pick image from gallery
  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      String imageName = pickedFile.name;
      File imageFile = File(pickedFile.path!);
      // Call uploadImage when image is picked
      final imageUrl = await uploadImage(imageName, imageFile);
      // Store imageUrl in Firestore
      CollectionReference profileImgsCollection =
          _firestore.collection('profileimgs');
      if (!(await profileImgsCollection.doc(loggedinInUser.email).get())
          .exists) {
        // Create the profileimgs collection if it doesn't exist
        await profileImgsCollection
            .doc(loggedinInUser.email)
            .set({'email': loggedinInUser.email});
      }
      await _firestore
          .collection('profileimgs')
          .doc(loggedinInUser.email)
          .update({
        'profile_image': imageUrl,
      });
      print("Image uploaded successfully");
    } else {
      print("XFile is null");
    }
  }

  // Method to upload image to Firebase Storage
  Future<String> uploadImage(String imageName, File imageFile) async {
    try {
      final reference = _storage.ref().child('profile_images/$imageName');
      final UploadTask uploadTask = reference.putFile(imageFile);
      await uploadTask.whenComplete(() {});
      final downloadUrl = await reference.getDownloadURL();
      return downloadUrl;
    } catch (error) {
      print("Error uploading image: $error");
      return ''; // Return empty string if upload fails
    }
  }

  Future<void> fetchProfileImage() async {
    final DocumentSnapshot snapshot = await _firestore
        .collection('profileimgs')
        .doc(loggedinInUser.email)
        .get();
    if (snapshot.exists) {
      final data = snapshot.data()
          as Map<String, dynamic>?; // Cast to Map<String, dynamic>?
      if (data != null) {
        setState(() {
          profileImageUrl = data['profile_image'];
        });
      } else {
        print('Data is null');
      }
    } else {
      print('Document does not exist');
    }
  }

  Widget allUserDetails() {
    return StreamBuilder(
        stream: UserDetailsStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return ds.get("email") == loggedinInUser.email
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(height: 30),
                              Center(
                                child: Stack(
                                  children: [
                                    profileImageUrl != null
                                        ? CircleAvatar(
                                            maxRadius: 80,
                                            backgroundColor: Color(0xFF00BE78),
                                            backgroundImage:
                                                NetworkImage(profileImageUrl!),
                                          )
                                        : CircleAvatar(
                                            maxRadius: 80,
                                            backgroundColor: Color(0xFF00BE78),
                                            backgroundImage: AssetImage(
                                                'images/defaultimage.png'),
                                          ),
                                    Positioned(
                                      bottom: -10,
                                      left: 100,
                                      child: IconButton(
                                        onPressed: pickImage, //selectImage,
                                        icon: Icon(
                                          Icons.add_a_photo,
                                          size: 40,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                // name is here
                                textAlign: TextAlign.center,
                                '' + ds["firstname"] + ' ' + ds["lastname"],
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 25),
                              ),
                              Text(
                                textAlign: TextAlign.center,
                                '',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 15, left: 15),
                                child: Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(30),
                                          bottom: Radius.circular(30)),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  'Age',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                Text(
                                                  '' +
                                                      ds["age"]
                                                          .toString(), // Replace with user's name
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 25,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  'Gender',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                Text(
                                                  '' + ds["gender"],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 25,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Divider(
                                          height: 40,
                                          indent: 50,
                                          endIndent: 50,
                                          thickness: 2,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  'Physical Impairments',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                Text(
                                                  '' +
                                                      ds["physical"], // Replace with user's name
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 25,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Divider(
                                          height: 40,
                                          indent: 50,
                                          endIndent: 50,
                                          thickness: 2,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  'Medical Conditions',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                Text(
                                                  '' +
                                                      ds["medical"], // Replace with user's name
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 25,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Divider(
                                          height: 40,
                                          indent: 50,
                                          endIndent: 50,
                                          thickness: 2,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  'Phone Number',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                Text(
                                                  '' +
                                                      ds["phoneno"]
                                                          .toString(), // Replace with user's name
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 25,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Divider(
                                          height: 40,
                                          indent: 50,
                                          endIndent: 50,
                                          thickness: 2,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  'email',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                Text(
                                                  '' +
                                                      ds["email"]
                                                          .toString(), // Replace with user's name
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 25,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _auth.signOut();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Firstpage(),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 50,
                                  width: 150,
                                  margin: EdgeInsets.symmetric(horizontal: 50),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF00BE78),
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Color(0xFF00BE78).withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Log Out',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 50,
                              ),
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
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          Expanded(child: allUserDetails()),
        ],
      ),
    );
  }
}
