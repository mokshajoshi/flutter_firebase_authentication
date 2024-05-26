import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/custom_widgets/custom_button.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController pswController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: body(),
        ),
      ),
    );
  }

  Widget body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 50,
        ),
        customTextField(
          emailController,
          TextInputType.emailAddress,
          "Enter Email",
        ),
        const SizedBox(
          height: 18,
        ),
        customTextField(
          pswController,
          TextInputType.text,
          "Enter Password",
        ),
        const SizedBox(
          height: 24,
        ),
        Row(
          children: [
            Expanded(
              child: CustomButton(
                btnText: "Create",
                btnColor: Colors.amber,
                onTap: () {
                  if (emailController.text.trim().isEmpty) {
                    showToast("Enter Email");
                  } else if (pswController.text.trim().isEmpty) {
                    showToast("Enter Password");
                  } else {
                    createAccount();
                  }
                },
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: CustomButton(
                btnText: "Login",
                btnColor: Colors.green,
                onTap: () {
                  if (emailController.text.trim().isEmpty) {
                    showToast("Enter Email");
                  } else if (pswController.text.trim().isEmpty) {
                    showToast("Enter Password");
                  } else {
                    loginUser();
                  }
                },
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: CustomButton(
                btnText: "Logout",
                btnColor: Colors.red,
                onTap: () {
                  if (emailController.text.trim().isNotEmpty &&
                      pswController.text.trim().isNotEmpty) {
                    logoutUser();
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget customTextField(
    TextEditingController controller,
    TextInputType keyboardType,
    String hintText,
  ) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black),
          ),
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.grey,
          )),
    );
  }

  createAccount() async {
    await Firebase.initializeApp();
    //  create new email-password
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: pswController.text.trim(),
      );

      print("Email --> ${credential.user!.email}");
      showToast("Account Created");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showToast("The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        showToast("The account already exists for that email.");
      }
    } catch (e) {
      print(e);
    }
  }

  loginUser() async {
    await Firebase.initializeApp();
    //  signin with email-password
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: pswController.text.trim());

      print("Email --> ${credential.user!.email}");
      showToast("Login Successfully");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showToast("No user found for that email.");
      } else if (e.code == 'wrong-password') {
        showToast("Wrong password provided for that user.");
      }
    }
  }

  logoutUser() async {
    await Firebase.initializeApp();
    await FirebaseAuth.instance.signOut();

    emailController.clear();
    pswController.clear();
    notify();

    print("Logout");
    showToast("Logout Successfully");
  }

  showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  notify() {
    if (mounted) setState(() {});
  }
}
