import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:na_hack/dashboardRec.dart';
import 'login_rec.dart';

class RegisterRecPage extends StatefulWidget {
  //final Function()? onTap;
  const RegisterRecPage({super.key});

  @override
  State<RegisterRecPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterRecPage> {
  // Text editing controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signUserUp() async {
    // Validate fields
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      showErrorMessage('Please fill in all fields');
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      showErrorMessage('Passwords do not match. Please try again.');
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Register the user in Firebase Auth
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Store user data in Firestore
      CollectionReference users =
          FirebaseFirestore.instance.collection('recepients');
      await users.doc(userCredential.user!.uid).set({
        // Store user data with UID as the document ID
        'name': nameController.text,
        'phone': phoneController.text,
        'address': addressController.text,
        'email': emailController.text,
        'username': usernameController.text,
        'password': passwordController.text,
      });

      Navigator.of(context).pop(); // Close loading dialog
      showErrorMessage('Registration Successful!');

      // Navigate to LoginPage after successful registration
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => DashboardRec(recId: users.id),
        ),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Close loading dialog
      if (e.code == 'wrong-password') {
        showErrorMessage('Incorrect password. Please try again.');
      } else if (e.code == 'user-not-found') {
        showErrorMessage('No user found for that email.');
      } else {
        showErrorMessage('Error: ${e.message}');
      }
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
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
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

                // Text fields
                _buildTextField("Name", nameController, 'Enter Name'),
                SizedBox(height: 20),
                _buildTextField(
                    "Phone No.", phoneController, 'Enter Phone No.'),
                SizedBox(height: 20),
                _buildTextField("Address", addressController, 'Enter Address'),
                SizedBox(height: 20),
                _buildTextField("Email", emailController, 'Enter Email'),
                SizedBox(height: 20),
                _buildTextField(
                    "Username", usernameController, 'Enter Username'),
                SizedBox(height: 20),
                _buildTextField(
                    "Password", passwordController, 'Enter Password',
                    obscureText: true),
                SizedBox(height: 20),
                _buildTextField("Confirm Password", confirmPasswordController,
                    'Re-enter Password',
                    obscureText: true),

                const SizedBox(height: 25),

                // Sign up button
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

                // Or continue with
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

                // Already have an account? Login now
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
                            builder: (context) => const LoginRecPage(
                                //onTap: null
                                ),
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

  // Simplified text field builder
  Widget _buildTextField(
      String label, TextEditingController controller, String hintText,
      {bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: hintText,
            fillColor: const Color.fromARGB(255, 191, 204, 206),
            filled: true,
          ),
          obscureText: obscureText,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
