import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; //
import 'package:flutter/material.dart';
import 'package:na_hack/dashboardDonor.dart';
import 'package:na_hack/login_donor.dart';

class RegisterDonorPage extends StatefulWidget {
  //final Function()? onTap;
  const RegisterDonorPage({super.key});

  @override
  State<RegisterDonorPage> createState() => _RegisterDonorPageState();
}

class _RegisterDonorPageState extends State<RegisterDonorPage> {
  // Text editing controllers
  final donorEmailController = TextEditingController();
  final donorNameController = TextEditingController();
  final donorUsernameController = TextEditingController();
  final donorPhoneController = TextEditingController();
  final donorPasswordController = TextEditingController();
  final donorConfirmPassController = TextEditingController();

  // Sign user up method
  void signUserUp() async {
    // Check if email or password is empty
    if (donorEmailController.text.isEmpty ||
        donorPasswordController.text.isEmpty ||
        donorConfirmPassController.text.isEmpty ||
        donorNameController.text.isEmpty ||
        donorPhoneController.text.isEmpty ||
        donorUsernameController.text.isEmpty) {
      showErrorMessage('Please fill in all fields');
      return;
    }

    if (donorPasswordController.text != donorConfirmPassController.text) {
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
        email: donorEmailController.text,
        password: donorPasswordController.text,
      );

      // Get the user's UID
      String uid = userCredential.user!.uid;

      // Create a Firestore reference
      CollectionReference users =
          FirebaseFirestore.instance.collection('donors');

      // Save user data to Firestore
      await users.doc(uid).set({
        'email': donorEmailController.text,
        'name': donorNameController.text,
        'username': donorUsernameController.text,
        'phone': donorPhoneController.text,
        'createdAt': Timestamp.now(),
      });

      // Pop the loading circle
      Navigator.of(context).pop(); // Close the loading dialog

      // Show success message
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Registration successful!')));

      // Navigate to LoginPage after successful registration
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginDonorPage(),
        ),
      );

      // Navigate to the next page
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => DashboardDonor(
                  donorId: users.id,
                )),
      );
    } on FirebaseAuthException catch (e) {
      // Pop the loading circle
      Navigator.of(context).pop(); // Close the loading dialog
      // Show error message
      showErrorMessage(e.message ?? "An error occurred");
    }
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
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  controller: donorEmailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Email',
                    fillColor: const Color.fromARGB(255, 191, 204, 206),
                    filled: true,
                  ),
                  obscureText: false,
                ),
                SizedBox(height: 20),
                _buildLabel("Fullname"),
                const SizedBox(height: 5),
                TextField(
                  controller: donorNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Fullname',
                    fillColor: const Color.fromARGB(255, 191, 204, 206),
                    filled: true,
                  ),
                  obscureText: false,
                ),
                const SizedBox(height: 20),
                _buildLabel("Phone Number"),
                const SizedBox(height: 5),
                TextField(
                  controller: donorPhoneController,
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
                  controller: donorUsernameController,
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
                  controller: donorPasswordController,
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
                  controller: donorConfirmPassController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Re-enter Password',
                    fillColor: const Color.fromARGB(255, 191, 204, 206),
                    filled: true,
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 25),
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
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LoginDonorPage(),
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

  Widget _buildLabel(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 17, 72, 84),
        ),
      ),
    );
  }
}
