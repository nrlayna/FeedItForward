import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:na_hack/campaign_detail.dart';

/*void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCYNb_s8qy1wSbKoHgJLB79tfdAjEmRAVc",
          authDomain: "feeditforward-hx.firebaseapp.com",
          //databaseURL: "https://feeditforward-hx.firebaseio.com",
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
      home: Campaign(),
      debugShowCheckedModeBanner: false,
    );
  }
}*/

class Campaign extends StatefulWidget {
  //final String documentId;

  Campaign({super.key});

  @override
  State<Campaign> createState() => _CampaignState();
}

class _CampaignState extends State<Campaign> {
  final CollectionReference idRef =
      FirebaseFirestore.instance.collection('organizations');

  final CollectionReference collRef =
      FirebaseFirestore.instance.collection('campaign');

  String dropdownvalue = 'All';

  var items = [
    'All',
    'Selangor',
    'Pahang',
    'Kedah',
    'Perak',
    'Perlis',
    'Melaka',
    'Negeri Sembilan',
    'Johor',
    'Penang',
    'Kelantan',
    'Terengganu',
    'Wilayah Persekutuan',
  ];

  Widget campaignList() {
    return StreamBuilder(
        stream: collRef.snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot documentSnapshot =
                        snapshot.data.docs[index];
                    return Material(
                      child: Container(
                        //color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                backgroundColor:
                                    const Color.fromARGB(255, 36, 145, 169),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => CampaignDetail(
                                      documentId: documentSnapshot.id,
                                      organizationId:
                                          documentSnapshot['organizationId'],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                height: 200,
                                width: 500,
                                //color: const Color.fromARGB(255, 163, 205, 241),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 36, 145, 169),
                                  // borderRadius:
                                  //   BorderRadius.all((Radius.circular(10))),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      documentSnapshot['title'],
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      documentSnapshot['desc'],
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'RM ${documentSnapshot['goals']}',
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.yellow,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Urgently Need Your Help',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
      body: SingleChildScrollView(
        child: Container(
          //height: 800,
          color: Colors.white,
          padding: const EdgeInsets.all(30),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Choose where to donate',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Each donation from you means thousands for them',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const Text(
                'Every single cents will be directly source to the recipient',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: 400,
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: DropdownButton(
                  alignment: Alignment.centerRight,
                  isExpanded: true,
                  value: dropdownvalue,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownvalue = newValue!;
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              campaignList(),
            ],
          ),
        ),
      ),
    );
  }
}
