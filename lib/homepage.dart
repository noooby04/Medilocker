import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _firebaseFirestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late User loggedinInUser;

  List<Map<String, dynamic>> pdfData = [];

  @override
  void initState() {
    getAllFile();
    getCurrentUser();
    super.initState();
  }

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

  Future<String> Uploadpdf(String filename, File pdfile) async {
    final pdfreference =
        FirebaseStorage.instance.ref().child("pdfs/$filename.pdf");

    final uploadTask = pdfreference.putFile(pdfile);

    await uploadTask.whenComplete(() {});

    final downloadLink = await pdfreference.getDownloadURL();

    return downloadLink;
  }

  void PickFile() async {
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (pickedFile != null) {
      String filename = pickedFile.files[0].name;
      File pdfile = File(pickedFile.files[0].path!);
      final downloadLink = await Uploadpdf(filename, pdfile);
      await _firebaseFirestore.collection("pdfs").add({
        "filename": filename,
        "url": downloadLink,
        "email": loggedinInUser.email,
      });
      print("pdf uploaded successfully");
    }
  }

  void getAllFile() async {
    final results = await _firebaseFirestore.collection("pdfs").get();

    pdfData = results.docs.map((e) => e.data()).toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'My Reports',
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
      body: GridView.builder(
          itemCount: pdfData.length,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, index) {
            return pdfData[index]['email'] == loggedinInUser.email
                ? Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => PdfViewerScreen(
                                    PdfUrl: pdfData[index]['url'])),
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.greenAccent,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                "images/translogo.png",
                                height: 80,
                                width: 100,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  pdfData[index]['filename'],
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : Container();
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.upload_file,
        ),
        onPressed: PickFile,
      ),
    );
  }
}

class PdfViewerScreen extends StatefulWidget {
  final String PdfUrl;
  const PdfViewerScreen({super.key, required this.PdfUrl});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  PDFDocument? document;

  void InilialisePdf() async {
    document = await PDFDocument.fromURL(widget.PdfUrl);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    InilialisePdf();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: document != null
          ? PDFViewer(
              document: document!,
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
