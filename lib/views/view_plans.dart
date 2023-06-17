import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/popup_menu.dart';
import 'package:mynotes/app_drawer.dart';
import 'dart:developer' as devtools show log;

import 'package:mynotes/main.dart';

final CollectionReference _refPlans = FirebaseFirestore.instance.collection('plans');
Stream<QuerySnapshot> _streamPlans = _refPlans.snapshots();

// initState(){
//   super.initState();
//   _streamPlans = _refPlans.snapshots();
// }

class ViewPlans extends StatefulWidget {
  const ViewPlans({Key? key}) : super(key: key);

  @override
  State<ViewPlans> createState() => _ViewPlansState();
}

class _ViewPlansState extends State<ViewPlans> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('View Plans'),
          actions: const [popupMenu()],
        ),
        drawer: const appDrawer(),
        body: StreamBuilder(
          stream: _streamPlans,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            if (snapshot.connectionState == ConnectionState.active) {
              QuerySnapshot data = snapshot.data;
              return Text(data.toString());
            }

            return CircularProgressIndicator();
          },
        )
    );
  }
}
