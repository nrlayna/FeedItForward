import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:na_hack/campaign.dart';
import 'package:na_hack/campaign_detail.dart';
import 'package:na_hack/emergency_alertOrg.dart';
import 'package:na_hack/inbox_org.dart';
import 'package:na_hack/profileOrg.dart';
import 'package:na_hack/req_organization.dart';

class DashboardOrg extends StatefulWidget {
  final String organizationId;

  DashboardOrg({required this.organizationId});

  @override
  _DashboardOrgState createState() => _DashboardOrgState();
}

class _DashboardOrgState extends State<DashboardOrg> {
  bool isLoading = true;
  List<Map<String, dynamic>> _campaigns = [];

  @override
  void initState() {
    super.initState();
    fetchCampaigns();
  }

  Future<void> fetchCampaigns() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('campaign').get();

      setState(() {
        _campaigns = snapshot.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          return {
            ...data,
            'documentId': doc.id, // Store the Firestore document ID
          };
        }).toList();
        isLoading = false;
      });

      // Debugging: Print fetched campaigns
      print("Fetched campaigns: $_campaigns");
    } catch (e) {
      print("Error fetching campaigns: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 17, 72, 84),
      body: isLoading
          ? Center(
              child: SpinKitFadingCircle(
                color: const Color.fromARGB(255, 17, 72, 84),
                size: 50.0,
              ),
            )
          : ListView(
              padding: EdgeInsets.all(20.0),
              children: [
                _buildHeader(),
                SizedBox(height: 20),
                _buildCampaignSection(context),
                SizedBox(height: 15),
                _buildImpactSection(),
              ],
            ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  ReqOrg(organizationId: widget.organizationId),
            ),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color.fromARGB(255, 104, 144, 166),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 17, 72, 84),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'FeedItForward',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
          ),
          SizedBox(height: 5),
          Text(
            'Let\'s donate together and fight food waste while feeding the hungry!',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
          ),
          SizedBox(height: 10),
          Image.asset(
            'images/dashboard.png',
            width: double.infinity,
            height: 180,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }

  Widget _buildCampaignSection(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Campaign(),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Suggested Campaigns For You',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 17, 72, 84),
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            _buildCampaignList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCampaignList() {
    return Container(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _campaigns.length,
        itemBuilder: (context, index) {
          final campaign = _campaigns[index];
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: _campaignCard(campaign),
          );
        },
      ),
    );
  }

  Widget _campaignCard(Map<String, dynamic> campaign) {
    var goals = campaign['goals'];

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CampaignDetail(
                documentId: campaign['documentId'],
                organizationId: campaign['organizationId']),
          ),
        );
      },
      child: Container(
        width: 200,
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 70, 179, 164),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              campaign['title'] ?? 'Untitled Campaign',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5),
            Text(
              campaign['desc'] ?? 'No description available',
              style: TextStyle(color: Colors.white, fontSize: 12),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 5),
            Text(
              'RM $goals',
              style: TextStyle(color: Colors.white, fontSize: 12),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImpactSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(45),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 0.5),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          _impactRow('RM37,987', 'thousands', 'raised'),
          _impactRow('45,922', 'donors', 'making impact'),
          _impactRow('25,467', 'thousands', 'helped'),
        ],
      ),
    );
  }

  Widget _impactRow(String amount, String unit, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            amount,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 5),
          Text(unit, style: TextStyle(fontSize: 14)),
          SizedBox(width: 5),
          Text(label, style: TextStyle(fontSize: 14)),
        ],
      ),
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
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) =>
                          DashboardOrg(organizationId: widget.organizationId),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.map, color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EmergencyAlertOrgPage(
                        orgId: widget.organizationId,
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
                      builder: (context) => InboxOrgPage(
                        orgId: widget.organizationId,
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.person, color: Colors.white, size: 30),
                onPressed: () {
                  // Implement your action for the profile button here
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProfileOrgPage(
                        documentId: widget.organizationId,
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
