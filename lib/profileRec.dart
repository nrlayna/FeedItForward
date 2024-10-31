import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:na_hack/dashboardRec.dart';

class ProfilePage extends StatefulWidget {
  final String recId;

  const ProfilePage({super.key, required this.recId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final CollectionReference collRef =
      FirebaseFirestore.instance.collection('recepients');

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  bool editMode = false;

  @override
  void initState() {
    super.initState();
    fetchUserData();

    // Debug print statement to confirm documentId
    print('Navigated to ProfilePage with documentId: ${widget.recId}');
  }

  Future<void> fetchUserData() async {
    print('Fetching user data for document ID: ${widget.recId}');

    if (widget.recId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid document ID')),
      );
      return;
    }

    try {
      DocumentSnapshot docSnapshot = await collRef.doc(widget.recId).get();
      print(
          'Fetched Document: ${docSnapshot.data()}'); // Print fetched document data

      if (docSnapshot.exists) {
        nameController.text = docSnapshot['name'] ?? '';
        usernameController.text = docSnapshot['username'] ?? '';
        addressController.text = docSnapshot['address'] ?? '';
        phoneController.text = docSnapshot['phone'] ?? '';
        emailController.text = docSnapshot['email'] ?? '';
        print('User data loaded successfully');
      } else {
        print('Document does not exist for ID: ${widget.recId}');
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
    if (widget.recId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid document ID')),
      );
      return;
    }

    try {
      await collRef.doc(widget.recId).update({
        'name': nameController.text,
        'username': usernameController.text,
        'address': addressController.text,
        'phone': phoneController.text,
        'email': emailController.text,
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
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => DashboardRec(recId: widget.recId)),
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
        stream: collRef.doc(widget.recId).snapshots(),
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
            nameController.text = ds['name'] ?? '';
            usernameController.text = ds['username'] ?? '';
            addressController.text = ds['address'] ?? '';
            phoneController.text = ds['phone'] ?? '';
            emailController.text = ds['email'] ?? '';
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
                          ? TextField(controller: nameController)
                          : TextBox(text: nameController.text),
                    ),
                    const SizedBox(height: 20),
                    ProfileSection(
                      title: "Email",
                      child: editMode
                          ? TextField(controller: emailController)
                          : TextBox(text: emailController.text),
                    ),
                    const SizedBox(height: 20),
                    ProfileSection(
                      title: "Username",
                      child: editMode
                          ? TextField(controller: usernameController)
                          : TextBox(text: usernameController.text),
                    ),
                    const SizedBox(height: 20),
                    ProfileSection(
                      title: "Phone",
                      child: editMode
                          ? TextField(controller: phoneController)
                          : TextBox(text: phoneController.text),
                    ),
                    const SizedBox(height: 20),
                    ProfileSection(
                      title: "Address",
                      child: editMode
                          ? TextField(controller: addressController)
                          : TextBox(text: addressController.text),
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
