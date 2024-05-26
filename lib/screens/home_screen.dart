import 'package:firebase_authentication/custom_widgets/custom_button.dart';
import 'package:firebase_authentication/screens/email_login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(child: body()),
    );
  }

  Widget body() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 50,
          ),
          CustomButton(
            btnText: "Login with Google",
            btnColor: Colors.red,
            onTap: () {
              googleSignIn();
            },
          ),
          const SizedBox(
            height: 18,
          ),
          CustomButton(
            btnText: "Login with Email",
            btnColor: Colors.amber,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EmailLoginScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  googleSignIn() async {
    List<String> scopes = ["email"];

    GoogleSignIn googleSignIn = GoogleSignIn(scopes: scopes);
    var user = await googleSignIn.signIn();

    if (user != null && (user.email != "" || user.email.isNotEmpty)) {
      print("Display Name --> ${user.displayName!}");
      print("Email --> ${user.email}");
    }
  }
}
