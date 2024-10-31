import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:na_hack/dashboardOrg.dart';
import 'package:na_hack/emergency_alertOrg.dart';
import 'package:na_hack/profileOrg.dart';
import 'package:na_hack/req_organization.dart';

class InboxOrgPage extends StatefulWidget {
  final String orgId;

  const InboxOrgPage({super.key, required this.orgId});

  @override
  // ignore: library_private_types_in_public_api
  _InboxOrgPage createState() => _InboxOrgPage();
}

class _InboxOrgPage extends State<InboxOrgPage> {
  bool isLoading = true;

  CollectionReference organizations =
      FirebaseFirestore.instance.collection('organizations');

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
                Expanded(
                  // Wrap StreamBuilder in Expanded to allow ListView to scroll
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('donation')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Center(child: Text('Error loading data'));
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                            child: Text('No donation requests available'));
                      }

                      // Display donation requests in a ListView
                      return ListView(
                        padding: const EdgeInsets.all(10),
                        children: snapshot.data!.docs.map((doc) {
                          var data = doc.data() as Map<String, dynamic>;
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 3,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['title'] ?? 'No title',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  data['desc'] ?? 'No description available',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  data['bankName'] ?? 'No bank name available',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  data['bankNo'] ?? 'No bank number available',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ],
            ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ReqOrg(organizationId: widget.orgId),
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
                icon: Icon(Icons.home, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) =>
                          DashboardOrg(organizationId: widget.orgId),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.map, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EmergencyAlertOrgPage(
                        orgId: widget.orgId,
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
                icon: Icon(Icons.notifications, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => InboxOrgPage(
                        orgId: widget.orgId,
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.person, color: Colors.white),
                onPressed: () {
                  // Implement your action for the profile button here
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProfileOrgPage(
                        documentId: widget.orgId,
                      ),
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
