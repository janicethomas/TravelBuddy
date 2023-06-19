import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import '../firebase_options.dart';
import 'package:mynotes/globals.dart' as globals;
import 'dart:developer' as devtools show log;

import 'package:mynotes/routes.dart';

import '../show_error_dialog.dart';



class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {

  late final TextEditingController _email = TextEditingController();
  late final TextEditingController _password = TextEditingController();
  late final TextEditingController _name = TextEditingController();
  late final TextEditingController _mobile = TextEditingController();
  late final CollectionReference _users = FirebaseFirestore.instance.collection('users');

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
    _name.dispose();
    _mobile.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: Column(
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
          TextField(
            controller: _name,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(
              hintText: 'Enter your name here',
            ),
          ),
          TextField(
            controller: _mobile,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              hintText: 'Enter your mobile no. here',
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                // final userCredential =
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: email,
                    password: password
                );

                final data = {
                  "user_email" : email,
                  "user_name" : _name.text,
                  "user_mobile" : _mobile.text
                };

                QuerySnapshot docRef = await _users.where("user_email", isEqualTo: email).get();
                if (docRef.docs.isEmpty) {
                  await _users.add(data);
                }
                else {
                  devtools.log(_users.id);
                }

                final user = FirebaseAuth.instance.currentUser;
                user?.sendEmailVerification();
                Navigator.of(context).pushNamed(verifyEmailRoute);
                // devtools.log(userCredential.toString());
              } on FirebaseAuthException catch(e) {
                if(e.code == 'weak-password') {
                  await showErrorDialog(context, 'Weak password');
                  devtools.log('Weak Password');
                }
                else if (e.code == 'email-already-in-use') {
                  await showErrorDialog(context, 'Email already in use');
                  devtools.log('Email is already in use');
                }
                else if(e.code == 'invalid-email') {
                  await showErrorDialog(context, 'Invalid email');
                  devtools.log('Invalid email');
                }
                else {
                  await showErrorDialog(context, 'Error: ${e.code}');
                }
              } catch (e) {
                await showErrorDialog(context, e.toString());
              }

            },
            child: const Text('Register'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute,
                        (route) => false
                );
              },
              child: const Text('Already registered? Login here')
          ),
        ],
      ),
    );
  }
}