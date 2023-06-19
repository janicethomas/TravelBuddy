import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import '../firebase_options.dart';
import 'package:mynotes/globals.dart' as globals;
import 'dart:developer' as devtools show log;
import 'package:mynotes/globals.dart';
import 'package:mynotes/routes.dart';

import '../show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email = TextEditingController();
  late final TextEditingController _password = TextEditingController();
  final CollectionReference _users = FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    // _email = TextEditingController();
    // _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Column(
        children: [
          Column(
            children: [
              TextField(
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Enter your email here',
                ),
              ),
              TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  hintText: 'Enter your password here',
                ),
              ),
              TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: email, password: password);
                    final user = FirebaseAuth.instance.currentUser;
                    if (user?.emailVerified ?? false) {
                      final colRef = FirebaseFirestore.instance.collection('users');
                      final snapshot = await colRef.where('user_email', isEqualTo: email).limit(1).get();
                      globals.userName = snapshot.docs.single['user_name'];
                      globals.userMobile = snapshot.docs.single['user_mobile'];
                      globals.userEmail = snapshot.docs.single['user_email'];

                      Navigator.of(context).pushNamedAndRemoveUntil(
                        // notesRoute,
                        viewPlansRoute,
                            (route) => false,
                      );
                    } else {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        verifyEmailRoute,
                            (route) => false,
                      );
                    }
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      await showErrorDialog(context, 'User not found');
                      devtools.log("User not found");
                    } else if (e.code == 'wrong-password') {
                      await showErrorDialog(context, 'Wrong credentials');
                      devtools.log("Wrong password");
                    }
                    else {
                      await showErrorDialog(context, 'Error: ${e.code}');
                    }
                  } catch (e) {
                    await showErrorDialog(context, e.toString());
                  }
                },
                child: const Text('Login'),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        registerRoute, (route) => false);
                  },
                  child: const Text('Not registered yet? Register here')),
            ],
          ),
        ],
      ),
    );
  }
}

