import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:na_hack/dashboardOrg.dart';
import 'package:na_hack/login_org.dart';

class RegisterOrgPage extends StatefulWidget {
  //final Function()? onTap;

  const RegisterOrgPage({super.key});

  @override
  State<RegisterOrgPage> createState() => _RegisterOrgPageState();
}

class _RegisterOrgPageState extends State<RegisterOrgPage> {
  // Text editing controllers
  final orgNameController = TextEditingController();
  final orgUsernameController = TextEditingController();
  final orgPhoneController = TextEditingController();
  final orgAddressController = TextEditingController();
  final orgRegController = TextEditingController();
  final businessPartnerController = TextEditingController();
  final orgEmailController = TextEditingController();
  final orgPasswordController = TextEditingController();
  final orgConfirmPasswordController = TextEditingController();

  // Dropdown variables
  String? selectedOrgType; // Holds the selected organization type
  final List<String> orgTypes = [
    'Non-Profit',
    'Charity',
    'Educational Institution',
    'Corporate',
  ];

  final List<TextEditingController> businessPartnerControllers = [
    TextEditingController()
  ];

  Future<void> signUserUp() async {
    // Check if fields are filled
    if (orgEmailController.text.isEmpty ||
            orgPasswordController.text.isEmpty ||
            orgConfirmPasswordController.text.isEmpty ||
            orgNameController.text.isEmpty ||
            selectedOrgType == null ||
            orgRegController.text.isEmpty ||
            orgPhoneController.text.isEmpty ||
            orgUsernameController.text.isEmpty ||
            orgAddressController.text.isEmpty
        //businessPartnerController.text.isEmpty
        ) {
      showErrorMessage('Please fill in all fields');
      return;
    }

    // Check if passwords match
    if (orgPasswordController.text != orgConfirmPasswordController.text) {
      showErrorMessage('Passwords do not match. Please try again.');
      return;
    }

    // Show loading circle
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing on tap
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Try creating the user
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: orgEmailController.text,
        password: orgPasswordController.text,
      );

      // Get the user's UID
      String uid = userCredential.user!.uid;

      // Create a Firestore reference
      CollectionReference organizations =
          FirebaseFirestore.instance.collection('organizations');

      // Add user data to Firestore with UID as the document ID
      await organizations.doc(uid).set({
        'organizationName': orgNameController.text,
        'organizationType': selectedOrgType,
        'registrationNumber': orgRegController.text,
        'businessPartner': businessPartnerController.text
            .split(',')
            .map((e) => e.trim())
            .toList(),
        'address': orgAddressController.text,
        'phone': orgPhoneController.text,
        'username': orgUsernameController.text,
        'email': orgEmailController.text,
        'password': orgPasswordController.text
      });

      // Pop the loading circle
      Navigator.of(context).pop(); // Close the loading dialog

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful!')));

      // Navigate to LoginPage after successful registration
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginOrgPage(),
        ),
      );

      // Navigate to the next page
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => DashboardOrg(
                  organizationId: organizations.id,
                )),
      );

      // // Navigate to the next page
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //       builder: (context) =>
      //           DashboardOrg(organizationId: organizations.id)),
      // );
    } on FirebaseAuthException catch (e) {
      // Pop the loading circle
      Navigator.of(context).pop(); // Close the loading dialog
      // Show error message
      showErrorMessage(e.message ?? "An error occurred");
    }
  }

  void addBusinessPartnerField() {
    setState(() {
      businessPartnerControllers.add(TextEditingController());
    });
  }

  void removeBusinessPartnerField(int index) {
    setState(() {
      businessPartnerControllers.removeAt(index);
    });
  }

  // Error message to the user
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 35, vertical: 5),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const SizedBox(height: 30),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(
                        'Hi !',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        'Welcome',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 45,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        'Let\'s create an account for you',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Color.fromARGB(255, 179, 171, 171),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildLabel("Email"),
                const SizedBox(height: 5),
                TextField(
                  controller: orgEmailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Email',
                    fillColor: const Color.fromARGB(255, 191, 204, 206),
                    filled: true,
                  ),
                  obscureText: false,
                ),
                const SizedBox(height: 20),
                _buildLabel("Organization Name"),
                const SizedBox(height: 5),
                TextField(
                  controller: orgNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Organization Name',
                    fillColor: const Color.fromARGB(255, 191, 204, 206),
                    filled: true,
                  ),
                  obscureText: false,
                ),
                const SizedBox(height: 20),
                _buildLabel("Organization Type"),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: DropdownButton<String>(
                      dropdownColor: const Color.fromARGB(255, 191, 204, 206),
                      value: selectedOrgType,
                      hint: const Text("Select Organization Type"),
                      items: orgTypes.map((String type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedOrgType = newValue;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildLabel("Registration Number"),
                const SizedBox(height: 5),
                TextField(
                  controller: orgRegController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Registration Number',
                    fillColor: const Color.fromARGB(255, 191, 204, 206),
                    filled: true,
                  ),
                  obscureText: false,
                ),
                const SizedBox(height: 20),
                _buildLabel("Address"),
                const SizedBox(height: 5),
                TextField(
                  controller: orgAddressController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Organization Address',
                    fillColor: const Color.fromARGB(255, 191, 204, 206),
                    filled: true,
                  ),
                  obscureText: false,
                ),
                const SizedBox(height: 20),
                _buildLabel("Business Partner"),
                const SizedBox(height: 5),
                Column(
                  children:
                      businessPartnerControllers.asMap().entries.map((entry) {
                    int index = entry.key;
                    TextEditingController controller = entry.value;
                    return Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter Business Partner',
                              fillColor:
                                  const Color.fromARGB(255, 191, 204, 206),
                              filled: true,
                            ),
                            obscureText: false,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle,
                              color: Colors.red),
                          onPressed: () => removeBusinessPartnerField(index),
                        ),
                      ],
                    );
                  }).toList(),
                ),
                TextButton.icon(
                  onPressed: addBusinessPartnerField,
                  icon: const Icon(Icons.add_circle, color: Colors.blue),
                  label: const Text('Add Business Partner'),
                ),
                const SizedBox(height: 20),
                _buildLabel("Phone Number"),
                const SizedBox(height: 5),
                TextField(
                  controller: orgPhoneController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Phone Number',
                    fillColor: const Color.fromARGB(255, 191, 204, 206),
                    filled: true,
                  ),
                  obscureText: false,
                ),
                const SizedBox(height: 20),
                _buildLabel("Username"),
                const SizedBox(height: 5),
                TextField(
                  controller: orgUsernameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Username',
                    fillColor: const Color.fromARGB(255, 191, 204, 206),
                    filled: true,
                  ),
                  obscureText: false,
                ),
                const SizedBox(height: 20),
                _buildLabel("Password"),
                const SizedBox(height: 5),
                TextField(
                  controller: orgPasswordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Password',
                    fillColor: const Color.fromARGB(255, 191, 204, 206),
                    filled: true,
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                _buildLabel("Confirm Password"),
                const SizedBox(height: 5),
                TextField(
                  controller: orgConfirmPasswordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Re-enter Password',
                    fillColor: const Color.fromARGB(255, 191, 204, 206),
                    filled: true,
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(300, 50),
                    foregroundColor: Colors.white,
                    backgroundColor: Color.fromARGB(255, 17, 72, 84),
                    textStyle:
                        TextStyle(fontSize: 20), // Set your desired font size
                  ),
                  onPressed: signUserUp,
                  child: const Text('Sign Up'),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LoginOrgPage(),
                          ),
                        );
                      },
                      child: const Text(
                        ' Login Now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Label builder
  Widget _buildLabel(String label) {
    return
        //Padding(
        //padding: const EdgeInsets.symmetric(horizontal: 25.0),
        Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: const TextStyle(
          color: Color.fromARGB(255, 17, 72, 84),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
