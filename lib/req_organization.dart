import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReqOrg extends StatefulWidget {
  final String organizationId;

  // Modify the constructor to accept organizationId
  const ReqOrg({super.key, required this.organizationId});

  @override
  State<ReqOrg> createState() => _ReqOrgState();
}

class _ReqOrgState extends State<ReqOrg> {
  final titleTEC = TextEditingController();
  final descTEC = TextEditingController();
  final goalTEC = TextEditingController();
  final locationTEC = TextEditingController();
  final bankNameTEC = TextEditingController();
  final bankNoTEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Request for donation',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
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
                  Text('TITLE OF DONATION',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 17, 72, 84))),
                  SizedBox(height: 10),
                  TextField(
                    controller: titleTEC,
                    decoration: InputDecoration(
                      fillColor: Color.fromARGB(255, 229, 246, 249),
                      filled: true,
                      border: OutlineInputBorder(),
                      hintText: 'Enter Title',
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'DETAILS OF THE DONATION',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(
                        255,
                        17,
                        72,
                        84,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  TextField(
                    controller: descTEC,
                    decoration: InputDecoration(
                      fillColor: Color.fromARGB(255, 229, 246, 249),
                      filled: true,
                      border: OutlineInputBorder(),
                      hintText: 'Share your reasons here',
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'DONATION GOAL (RM)',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 17, 72, 84),
                    ),
                  ),
                  SizedBox(height: 5),
                  TextField(
                    controller: goalTEC,
                    decoration: InputDecoration(
                      fillColor: Color.fromARGB(255, 229, 246, 249),
                      filled: true,
                      border: OutlineInputBorder(),
                      hintText: 'Enter Amount',
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'LOCATION',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 17, 72, 84),
                    ),
                  ),
                  SizedBox(height: 5),
                  TextField(
                    controller: locationTEC,
                    decoration: InputDecoration(
                      fillColor: Color.fromARGB(255, 229, 246, 249),
                      filled: true,
                      border: OutlineInputBorder(),
                      hintText: 'Enter Address',
                    ),
                  ),
                  SizedBox(height: 30),
                  Text('BANK NAME',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 17, 72, 84),
                      )),
                  SizedBox(height: 5),
                  TextField(
                    controller: bankNameTEC,
                    decoration: InputDecoration(
                      fillColor: Color.fromARGB(255, 229, 246, 249),
                      filled: true,
                      border: OutlineInputBorder(),
                      hintText: 'Enter Bank Name',
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'BANK ACCOUNT NUMBER',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 17, 72, 84),
                    ),
                  ),
                  SizedBox(height: 5),
                  TextField(
                    controller: bankNoTEC,
                    decoration: InputDecoration(
                      fillColor: Color.fromARGB(255, 229, 246, 249),
                      filled: true,
                      border: OutlineInputBorder(),
                      hintText: 'Enter Account Number',
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
              Container(height: 20),
              //const SizedBox(height: 5),
              Container(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  backgroundColor: const Color.fromARGB(255, 17, 72, 84),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  fixedSize: const Size(400, 50),
                ),
                onPressed: () async {
                  CollectionReference collRef =
                      FirebaseFirestore.instance.collection('campaign');

                  try {
                    await collRef.add({
                      'title': titleTEC.text,
                      'desc': descTEC.text,
                      'goals': goalTEC.text,
                      'location': locationTEC.text,
                      'bankName': bankNameTEC.text,
                      'bankNo': bankNoTEC.text,
                      'organizationId':
                          widget.organizationId, // Link the organization ID
                    });

                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Request submitted successfully!',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: Color.fromARGB(255, 17, 72, 84),
                      ),
                    );

                    // Clear input fields after successful submission
                    titleTEC.clear();
                    descTEC.clear();
                    goalTEC.clear();
                    locationTEC.clear();
                    bankNameTEC.clear();
                    bankNoTEC.clear();
                  } catch (e) {
                    // Show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to submit request: $e',
                            style: TextStyle(color: Colors.white)),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
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
