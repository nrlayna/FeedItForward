import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dashboardDonor.dart';
import 'emergency_alertDonor.dart';
import 'inboxDonor.dart';
import 'profileDonor.dart';

class DonorProfilePage extends StatefulWidget {
  final String donorId;

  DonorProfilePage({required this.donorId});

  @override
  _DonorProfilePage createState() => _DonorProfilePage();
}

class _DonorProfilePage extends State<DonorProfilePage> {
  String donorName = ''; // Variable to hold the donor's name
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDonorData();
  }

  Future<void> _fetchDonorData() async {
    try {
      DocumentSnapshot donorDoc = await FirebaseFirestore.instance
          .collection('donors')
          .doc(widget.donorId)
          .get();

      if (donorDoc.exists) {
        setState(() {
          donorName = donorDoc['name'] ?? 'Unknown'; // Get the donor's name
          isLoading = false;
        });
      } else {
        setState(() {
          donorName = 'Unknown';
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching donor data: $e");
      setState(() {
        donorName = 'Error fetching name';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Badges',
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8.0,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 16.0),
                      child: Column(
                        children: [
                          isLoading
                              ? CircularProgressIndicator()
                              : Text(
                                  donorName, // Display the retrieved donor name
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                          Text(
                            'PUBLIC DONOR',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 25),
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              'https://storage.googleapis.com/a1aa/image/ipelXsTmeio3EkclSKxy1GkKTZ0XyPK0FgWBJy1ekvxgf8uOB.jpg',
                            ),
                            radius: 50,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'TOTAL DONATION',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'RM 67 000',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[800],
                            ),
                          ),
                          SizedBox(height: 25),
                          Text(
                            'Collect 277 stars more to go to the next level',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                          // SizedBox(height: 3),
                          // Progress bar
                          Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              // LinearProgressIndicator, covering full width
                              LinearProgressIndicator(
                                value: 0.5,
                                backgroundColor: Colors.yellow[200],
                                color: Colors.yellow[700],
                                minHeight: 5,
                              ),
                              // Positioned star icon at the end of the progress
                              Align(
                                alignment: Alignment(-1.0 + (0.5 * 2),
                                    0.0), // Adjusts based on progress
                                child: Icon(
                                  Icons.star,
                                  color: Colors.yellow[700],
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          // Quests section
                          Text(
                            'QUESTS',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            childAspectRatio: 2 / 1.2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            children: List.generate(6, (index) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.green[200],
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'images/quest.png',
                                      height: 40,
                                      width: 40,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'DONATE AT LEAST RM10 3 DAYS IN A ROW',
                                      style: TextStyle(fontSize: 12),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DonorProfilePage(donorId: widget.donorId),
            ),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color.fromARGB(255, 104, 144, 166),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomAppBar(
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
                      builder: (context) =>
                          DashboardDonor(donorId: widget.donorId),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.map, color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EmergencyAlertDonorPage(
                        donorId: widget.donorId,
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
                icon: Icon(Icons.notifications, color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => InboxDonorPage(
                        donorId: widget.donorId,
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
                      builder: (context) =>
                          ProfileDonorPage(donorId: widget.donorId),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
