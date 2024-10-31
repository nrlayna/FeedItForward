import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:na_hack/dashboardOrg.dart';

class ProfileOrgPage extends StatefulWidget {
  final String documentId;

  const ProfileOrgPage({super.key, required this.documentId});

  @override
  _ProfileOrgPageState createState() => _ProfileOrgPageState();
}

class _ProfileOrgPageState extends State<ProfileOrgPage> {
  final CollectionReference collRef =
      FirebaseFirestore.instance.collection('organizations');

  // Controllers for the text fields
  final TextEditingController orgNameController = TextEditingController();
  final TextEditingController orgEmailController = TextEditingController();
  final TextEditingController orgTypeController = TextEditingController();
  final TextEditingController organizedByController = TextEditingController();
  final TextEditingController businessPartnerController =
      TextEditingController();
  final TextEditingController orgUsernameController = TextEditingController();
  final TextEditingController registrationNoController =
      TextEditingController();
  final TextEditingController orgAddressController = TextEditingController();
  final TextEditingController phoneNoController = TextEditingController();

  bool editMode = false;

  @override
  void initState() {
    super.initState();
    fetchUserData();

    // Debug print statement to confirm documentId
    print('Navigated to ProfilePage with documentId: ${widget.documentId}');
  }

  Future<void> fetchUserData() async {
    print('Fetching user data for document ID: ${widget.documentId}');

    if (widget.documentId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid document ID')),
      );
      return;
    }

    try {
      DocumentSnapshot docSnapshot = await collRef.doc(widget.documentId).get();
      print(
          'Fetched Document: ${docSnapshot.data()}'); // Print fetched document data

      if (docSnapshot.exists) {
        orgNameController.text = docSnapshot['organizationName'] ?? '';
        orgUsernameController.text = docSnapshot['username'] ?? '';
        orgAddressController.text = docSnapshot['address'] ?? '';
        phoneNoController.text = docSnapshot['phone'] ?? '';
        orgEmailController.text = docSnapshot['email'] ?? '';
        print('User data loaded successfully');
      } else {
        print('Document does not exist for ID: ${widget.documentId}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Document does not exist')),
        );
      }
    } catch (e) {
      print('Error fetching data: $e'); // Print error for debugging
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch data: $e')),
      );
    }
  }

  void saveChanges() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (widget.documentId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid document ID')),
      );
      return;
    }
    try {
      await collRef.doc(widget.documentId).update({
        'organizationName': orgNameController.text,
        'organizationType': orgTypeController.text,
        'organizedBy': organizedByController.text,
        'businessPartner': businessPartnerController.text,
        'username': orgUsernameController.text,
        'address': orgAddressController.text,
        'phone': phoneNoController.text,
        'registrationNumber': registrationNoController.text,
      });

      setState(() {
        editMode = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Changes have been saved!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save changes: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 17, 72, 84),
        title: const Text(
          'Profile',
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
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) =>
                      DashboardOrg(organizationId: widget.documentId)),
            );
          },
        ),
        actions: [
          IconButton(
            icon:
                Icon(editMode ? Icons.check : Icons.edit, color: Colors.white),
            onPressed: () {
              if (editMode) {
                saveChanges();
              } else {
                setState(() {
                  editMode = true;
                });
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: collRef.doc(widget.documentId).snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Document does not exist'));
          }

          DocumentSnapshot ds = snapshot.data!;

          // Populate the controllers with data from Firestore
          if (!editMode) {
            orgNameController.text = ds['organizationName'] ?? '';
            orgTypeController.text = ds['organizationType'] ?? '';
            //organizedByController.text = ds['organizedBy'] ?? '';
            orgEmailController.text = ds['email'] ?? '';
            // businessPartnerController.text = ds['businessPartner'] ?? '';
            orgUsernameController.text = ds['username'] ?? '';
            registrationNoController.text = ds['registrationNumber'] ?? '';
            orgAddressController.text = ds['address'] ?? '';
            phoneNoController.text = ds['phone'] ?? '';
          }

          return Container(
            padding:
                const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ProfileSection(
                      title: "Name",
                      child: editMode
                          ? TextField(controller: orgNameController)
                          : TextBox(text: orgNameController.text),
                    ),
                    const SizedBox(height: 20),
                    ProfileSection(
                      title: "Username",
                      child: editMode
                          ? TextField(controller: orgUsernameController)
                          : TextBox(text: orgUsernameController.text),
                    ),
                    const SizedBox(height: 20),
                    ProfileSection(
                      title: "Email",
                      child: editMode
                          ? TextField(controller: orgEmailController)
                          : TextBox(text: orgEmailController.text),
                    ),
                    const SizedBox(height: 20),
                    ProfileSection(
                      title: "Organization Type",
                      child: editMode
                          ? TextField(controller: orgTypeController)
                          : TextBox(text: orgTypeController.text),
                    ),
                    const SizedBox(height: 20),
                    ProfileSection(
                      title: "Contact No",
                      child: editMode
                          ? TextField(controller: phoneNoController)
                          : TextBox(text: phoneNoController.text),
                    ),
                    const SizedBox(height: 20),
                    ProfileSection(
                      title: "Registration No",
                      child: editMode
                          ? TextField(controller: registrationNoController)
                          : TextBox(text: registrationNoController.text),
                    ),
                    const SizedBox(height: 20),
                    ProfileSection(
                      title: "Business Partner",
                      child: editMode
                          ? TextField(controller: businessPartnerController)
                          : TextBox(text: businessPartnerController.text),
                    ),
                    const SizedBox(height: 16),
                    if (editMode)
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: ElevatedButton(
                          child: Text(
                            'Save Changes',
                            style: TextStyle(fontSize: 18),
                          ),
                          onPressed: saveChanges,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Color.fromARGB(255, 17, 72, 84),
                            minimumSize: Size(200, 50),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 15),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProfileSection extends StatelessWidget {
  final String title;
  final Widget child;

  const ProfileSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 17, 72, 84)),
        ),
        const SizedBox(height: 16),
        Container(
          width: 400,
          height: 50,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 229, 246, 249),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: const Color.fromARGB(85, 11, 45, 72), width: 2),
          ),
          child: child,
        ),
      ],
    );
  }
}

class TextBox extends StatelessWidget {
  final String text;

  const TextBox({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
    );
  }
}

class PartnerLogo extends StatelessWidget {
  final String imageUrl;

  const PartnerLogo({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.network(imageUrl, fit: BoxFit.contain),
      ),
    );
  }
}
