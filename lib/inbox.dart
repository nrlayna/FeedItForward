import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:na_hack/dashboardRec.dart';
import 'package:na_hack/foodbank.dart';
import 'package:na_hack/profileRec.dart';
import 'package:na_hack/req_recepient.dart';

class InboxPage extends StatefulWidget {
  final String recId;

  const InboxPage({super.key, required this.recId});

  @override
  // ignore: library_private_types_in_public_api
  _InboxPage createState() => _InboxPage();
}

class _InboxPage extends State<InboxPage> {
  bool isLoading = true;

  CollectionReference rec = FirebaseFirestore.instance.collection('recepients');

  @override
  void initState() {
    super.initState();
    // Simulate a loading delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false; // Set loading to false after delay
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Inbox',
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
        backgroundColor: const Color.fromARGB(255, 17, 72, 84),
      ),
      body: isLoading
          ? const Center(
              child: SpinKitFadingCircle(
                color: Color.fromARGB(255, 17, 72, 84),
                size: 50.0,
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: const ListTile(
                    title: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Align items to the start
                      children: [
                        Text(
                          'All notifications will be notified here',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 10), // Adjust the spacing as needed
                        Icon(
                          Icons.notifications,
                          size: 30,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
                // Uncomment and adjust the ListView as needed
                // Expanded(
                //   child: Container(
                //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                //     child: ListView.builder(
                //       itemCount: _places.length,
                //       itemBuilder: (context, index) {
                //         var place = _places[index];
                //         return Container(
                //           margin: EdgeInsets.symmetric(vertical: 3.0),
                //           padding: EdgeInsets.all(15.0),
                //           decoration: BoxDecoration(
                //             color: Color.fromARGB(255, 216, 216, 216),
                //             borderRadius: BorderRadius.circular(3.0),
                //           ),
                //           child: ListTile(
                //             trailing: const Icon(Icons.location_pin,
                //                 color: Color.fromARGB(255, 0, 0, 0)),
                //             title: Text(
                //               place['name'], // Display the place name
                //               style: TextStyle(
                //                   fontSize: 18,
                //                   fontWeight: FontWeight.bold,
                //                   color: const Color.fromARGB(255, 0, 0, 0)),
                //             ),
                //             subtitle: Text(
                //               place['address'], // Display the place description
                //               style: TextStyle(
                //                   fontSize: 16,
                //                   color: const Color.fromARGB(255, 0, 0, 0)),
                //             ),
                //             onTap: () {
                //               _moveCameraToPlace(place['position']);
                //               _showPlaceDetails(place);
                //             },
                //           ),
                //         );
                //       },
                //     ),
                //   ),
                // ),
              ],
            ),
      bottomNavigationBar: BottomAppBar(
        color: Color.fromARGB(255, 17, 72, 84),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.home, color: Colors.white, size: 30),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DashboardRec(recId: widget.recId),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.map, color: Colors.white, size: 30),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FoodbankPage(
                          recId: widget.recId,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon:
                      Icon(Icons.notifications, color: Colors.white, size: 30),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => InboxPage(
                          recId: widget.recId,
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.person, color: Colors.white, size: 30),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(
                          recId: widget.recId,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ReqRcp(
                recId: widget.recId,
              ),
            ),
          );
        },
        backgroundColor: const Color.fromARGB(255, 104, 144, 166),
        child: const Icon(
          Icons.add,
          color: Colors.white, // Set the icon color to white
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
