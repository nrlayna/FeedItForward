import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:na_hack/scanqr.dart';

class CampaignDetail extends StatelessWidget {
  final String documentId;
  final String organizationId;

  const CampaignDetail(
      {super.key, required this.documentId, required this.organizationId});

  @override
  Widget build(BuildContext context) {
    final CollectionReference campaignRef =
        FirebaseFirestore.instance.collection('campaign');
    final CollectionReference orgRef =
        FirebaseFirestore.instance.collection('organizations');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Campaign Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 17, 72, 84),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: campaignRef.doc(documentId).snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> campaignSnapshot) {
          if (campaignSnapshot.hasError) {
            return const Center(child: Text('Error fetching campaign data'));
          }
          if (!campaignSnapshot.hasData || !campaignSnapshot.data!.exists) {
            return const Center(child: Text('Campaign does not exist'));
          }

          var campaignData = campaignSnapshot.data!;
          return Container(
            padding: const EdgeInsets.all(30),
            //color: const Color.fromRGBO(187, 183, 229, 100),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    campaignData['title'],
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(campaignData['desc'],
                      style: const TextStyle(fontSize: 15)),
                  const SizedBox(height: 20),

                  // Contact Information Header
                  const Text(
                    'CONTACT INFORMATION',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 17, 72, 84)),
                  ),
                  const SizedBox(height: 10),

                  // StreamBuilder for Organization Information
                  StreamBuilder<DocumentSnapshot>(
                    stream: orgRef.doc(organizationId).snapshots(),
                    builder:
                        (context, AsyncSnapshot<DocumentSnapshot> orgSnapshot) {
                      if (orgSnapshot.hasError) {
                        return const Text('Error fetching organization data');
                      }
                      if (!orgSnapshot.hasData || !orgSnapshot.data!.exists) {
                        return const Text('Organization details not available');
                      }
                      var orgData = orgSnapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Organization Name: ${orgData['organizationName']}', // Assuming 'name' field exists in 'organizations'
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.normal),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Email: ${orgData['email']}', // Assuming 'email' field exists in 'organizations'
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.normal),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Phone: ${orgData['phone']}', // Assuming 'phone' field exists in 'organizations'
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.normal),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Organization Type: ${orgData['organizationType']}', // Assuming 'type' field exists in 'organizations'
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.normal),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      'RM ${campaignData['goals']}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ScanQR(
                            documentId: documentId,
                            organizationId: organizationId),
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 17, 72, 84),
                      fixedSize: const Size(400, 50),
                    ),
                    child: const Text('Donate',
                        style: TextStyle(
                            fontSize: 20,
                            //fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
