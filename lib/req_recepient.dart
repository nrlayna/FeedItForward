import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

/*void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCYNb_s8qy1wSbKoHgJLB79tfdAjEmRAVc",
          authDomain: "feeditforward-hx.firebaseapp.com",
          projectId: "feeditforward-hx",
          storageBucket: "feeditforward-hx.appspot.com",
          messagingSenderId: "16136800196",
          appId: "1:16136800196:web:5c38070fdeddd43e010691"));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ReqRcp(),
      debugShowCheckedModeBanner: false,
    );
  }
}*/

class ReqRcp extends StatefulWidget {
  final String recId;

  // Modify the constructor to accept organizationId
  const ReqRcp({super.key, required this.recId});
  @override
  State<ReqRcp> createState() => _ReqRcpState();
}

class _ReqRcpState extends State<ReqRcp> {
  final titleTEC = TextEditingController();
  final descTEC = TextEditingController();
  final bankNameTEC = TextEditingController();
  final bankNoTEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request for donation',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Color.fromARGB(255, 17, 72, 84),
      ),
      body: Container(
        height: 800,
        color: Colors.white,
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'TITLE OF DONATION',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 17, 72, 84),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: titleTEC,
                    decoration: InputDecoration(
                      fillColor: Color.fromARGB(255, 229, 246, 249),
                      filled: true,
                      border: OutlineInputBorder(),
                      hintText: 'Enter Title',
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'DETAILS OF THE DONATION',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 17, 72, 84),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: descTEC,
                    decoration: InputDecoration(
                      fillColor: Color.fromARGB(255, 229, 246, 249),
                      filled: true,
                      border: OutlineInputBorder(),
                      hintText: 'Share your reasons here',
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'BANK NAME',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 17, 72, 84),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: bankNameTEC,
                    decoration: InputDecoration(
                      fillColor: Color.fromARGB(255, 229, 246, 249),
                      filled: true,
                      border: OutlineInputBorder(),
                      hintText: 'Enter Bank Name',
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'BANK ACCOUNT NUMBER',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 17, 72, 84),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: bankNoTEC,
                    decoration: InputDecoration(
                      fillColor: Color.fromARGB(255, 229, 246, 249),
                      filled: true,
                      border: OutlineInputBorder(),
                      hintText: 'Enter Account Number',
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
              Container(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  backgroundColor: const Color.fromARGB(255, 17, 72, 84),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  fixedSize: const Size(400, 50),
                ),
                onPressed: () {
                  CollectionReference collRef =
                      FirebaseFirestore.instance.collection('donation');
                  collRef.add({
                    'title': titleTEC.text,
                    'desc': descTEC.text,
                    'bankName': bankNameTEC.text,
                    'bankNo': bankNoTEC.text,
                    'recId': widget.recId,
                  });
                  /*Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const Signup(),
                              ),
                            );*/
                },
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Submit request',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
