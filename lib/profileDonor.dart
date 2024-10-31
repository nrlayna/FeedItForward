import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:na_hack/dashboardDonor.dart';

class ProfileDonorPage extends StatefulWidget {
  final String donorId;

  const ProfileDonorPage({super.key, required this.donorId});

  @override
  _ProfileDonorPageState createState() => _ProfileDonorPageState();
}

class _ProfileDonorPageState extends State<ProfileDonorPage> {
  final CollectionReference collRef =
      FirebaseFirestore.instance.collection('donors');

  final TextEditingController donorUsernameController = TextEditingController();
  final TextEditingController donorNameController = TextEditingController();
  final TextEditingController donorEmailController = TextEditingController();
  final TextEditingController donorPhoneController = TextEditingController();
  final TextEditingController donorAddressController = TextEditingController();

  bool editMode = false;

  @override
  void initState() {
    super.initState();
  }

  void saveChanges() async {
    try {
      await FirebaseFirestore.instance
          .collection('donors')
          .doc(widget.donorId) // Use the passed documentId
          .update({
        'name': donorNameController.text,
        'username': donorUsernameController.text,
        'address': donorAddressController.text,
        'phone': donorPhoneController.text,
        'email': donorEmailController.text,
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
        title: const Text('Profile',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) =>
                      DashboardDonor(donorId: widget.donorId)),
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
        stream: collRef.doc(widget.donorId).snapshots(),
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
            donorNameController.text = ds['name'] ?? '';
            donorUsernameController.text = ds['username'] ?? '';
            donorAddressController.text = ds['address'] ?? '';
            donorPhoneController.text = ds['phone'] ?? '';
            donorEmailController.text = ds['email'] ?? '';
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
                          ? TextField(controller: donorNameController)
                          : TextBox(text: donorNameController.text),
                    ),
                    const SizedBox(height: 20),
                    ProfileSection(
                      title: "Email",
                      child: editMode
                          ? TextField(controller: donorEmailController)
                          : TextBox(text: donorEmailController.text),
                    ),
                    const SizedBox(height: 20),
                    ProfileSection(
                      title: "Username",
                      child: editMode
                          ? TextField(controller: donorUsernameController)
                          : TextBox(text: donorUsernameController.text),
                    ),
                    const SizedBox(height: 20),
                    ProfileSection(
                      title: "Phone",
                      child: editMode
                          ? TextField(controller: donorPhoneController)
                          : TextBox(text: donorPhoneController.text),
                    ),
                    const SizedBox(height: 20),
                    ProfileSection(
                      title: "Address",
                      child: editMode
                          ? TextField(controller: donorAddressController)
                          : TextBox(text: donorAddressController.text),
                    ),
                    const SizedBox(height: 20),
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
