import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:na_hack/dashboardDonor.dart';
import 'package:na_hack/register_donor.dart';

class LoginDonorPage extends StatefulWidget {
  //final Function()? onTap;
  final TextEditingController? usernameController;
  final TextEditingController? passwordController;

  const LoginDonorPage(
      {super.key,
      //required this.onTap,
      this.usernameController,
      this.passwordController});

  @override
  State<LoginDonorPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginDonorPage> {
  late TextEditingController usernameController;
  late TextEditingController passwordController;

  void initState() {
    super.initState();
    usernameController = widget.usernameController ?? TextEditingController();
    passwordController = widget.passwordController ?? TextEditingController();
  }

  void signUserIn() async {
    // Show loading circle
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // Try sign in
    try {
      // Query Firestore to find user with the given username and password
      var userDoc = await FirebaseFirestore.instance
          .collection('donors') // Change this to the appropriate collection
          .where('username', isEqualTo: usernameController.text)
          .get();

      if (userDoc.docs.isEmpty) {
        Navigator.pop(context); // Close loading dialog
        // Username not found
        showErrorMessage('Username not found.');
        return;
      }

      // Get the email associated with the username
      String email = userDoc.docs.first['email'];
      String donorId = userDoc.docs.first.id;

      // Attempt sign-in with Firebase Auth
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: passwordController.text,
      );

      // Close the loading dialog
      Navigator.pop(context);

      showErrorMessage('Login Successful!'); // Success message

      // Navigate to home page
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => DashboardDonor(
            donorId: donorId,
          ),
        ),
      );
    } on FirebaseAuthException {
      Navigator.pop(context);
      showErrorMessage('Incorrect username or password.');
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Message'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Image.asset(
                  'images/login.png',
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 30),
                const Text(
                  'Welcome to',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'FeedItForward',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Already have an account? Log in now',
                  style: TextStyle(
                    color: Color.fromARGB(255, 179, 171, 171),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 17),

                // Username textfield
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Username',
                  ),
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // Password textfield
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Password',
                  ),
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                // Forgot password?
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                // Sign in button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(300, 50),
                    foregroundColor: Colors.white,
                    backgroundColor: Color.fromARGB(255, 17, 72, 84),
                    textStyle:
                        TextStyle(fontSize: 20), // Set your desired font size
                  ),
                  onPressed: signUserIn,
                  child: const Text('Sign In'),
                ),

                const SizedBox(height: 50),

                // Or continue with
                Row(
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

                const SizedBox(height: 30),

                // Not a member? Register
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Not a member?',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(width: 4),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => RegisterDonorPage(),
                          ),
                        );
                      },
                      child: const Text(
                        ' Register Now',
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
}
