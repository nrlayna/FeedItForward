import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:na_hack/login_donor.dart';
import 'package:na_hack/login_org.dart';
import 'package:na_hack/login_rec.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCYNb_s8qy1wSbKoHgJLB79tfdAjEmRAVc",
          authDomain: "feeditforward-hx.firebaseapp.com",
          //databaseURL: "https://feeditforward-hx.firebaseio.com",
          projectId: "feeditforward-hx",
          storageBucket: "feeditforward-hx.appspot.com",
          messagingSenderId: "16136800196",
          appId: "1:16136800196:web:5c38070fdeddd43e010691"));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feed It Forward',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StartPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class StartPage extends StatelessWidget {
  void onRecipientTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginRecPage(),
      ),
    );
  }

  void onPublicDonorTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginDonorPage(),
      ),
    );
  }

  void onOrganizationTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginOrgPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Box containing the question
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "WHICH ROLE ARE YOU?",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 17, 72, 84),
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 30),

            // Recipient button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(300, 70),
                foregroundColor: Colors.white,
                backgroundColor: Color.fromARGB(255, 17, 72, 84),
                textStyle:
                    TextStyle(fontSize: 20), // Set your desired font size
              ),
              onPressed: () => onRecipientTap(context),
              child: Text(
                'Recipient',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Public Donor button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(300, 70),
                foregroundColor: Colors.white,
                backgroundColor: Color.fromARGB(255, 17, 72, 84),
                textStyle:
                    TextStyle(fontSize: 20), // Set your desired font size
              ),
              onPressed: () => onPublicDonorTap(context),
              child: Text(
                'Public Donor',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Organization button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(300, 70),
                foregroundColor: Colors.white,
                backgroundColor: Color.fromARGB(255, 17, 72, 84),
                textStyle:
                    TextStyle(fontSize: 20), // Set your desired font size
              ),
              onPressed: () => onOrganizationTap(context),
              child: Text(
                'Organization',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  final Function()? onTap;
  final String text;

  const Button({
    super.key,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 25),
        margin: const EdgeInsets.symmetric(horizontal: 60),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 17, 72, 84),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
