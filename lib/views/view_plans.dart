import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mynotes/popup_menu.dart';
import 'package:mynotes/app_drawer.dart';
import 'dart:developer' as devtools show log;

import 'package:mynotes/main.dart';
import 'package:mynotes/routes.dart';

class ViewPlans extends StatefulWidget {
  const ViewPlans({Key? key}) : super(key: key);

  @override
  State<ViewPlans> createState() => _ViewPlansState();
}

class _ViewPlansState extends State<ViewPlans> {
  late final CollectionReference _refPlans =
      FirebaseFirestore.instance.collection('plans');
  late final CollectionReference _refUsers =
      FirebaseFirestore.instance.collection('users');

  late final Stream<QuerySnapshot> _streamPlans;
  late final Stream<QuerySnapshot> _streamUsers;

  @override
  initState() {
    super.initState();
    _streamPlans = _refPlans.snapshots();
    _streamUsers = _refUsers.snapshots();
  }

  @override
  void dispose() {
    _streamUsers;
    _streamPlans;
    super.dispose();
  }

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
              QuerySnapshot querySnapshot = snapshot.data;
              return ListView.builder(
                  itemCount: querySnapshot!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot docSnapshot =
                        querySnapshot!.docs[index];
                    final dateTime =
                        docSnapshot['plan_start_datetime'].toDate();
                    final startingDate = DateFormat.yMMMd().format(dateTime);
                    final startingTime = DateFormat.jm().format(dateTime);
                    final planMode = docSnapshot['plan_mode'];
                    final isFlexible = docSnapshot['plan_flexible'].toString();
                    final pax = docSnapshot['plan_pax'];

                    return Card(
                        margin: const EdgeInsets.all(10),
                        child: ExpansionTile(
                          title: Text(docSnapshot['plan_starting_point'] +
                              " -> " +
                              docSnapshot['plan_dest']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Start date: $startingDate"),
                              Text("Start time: $startingTime"),
                            ],
                          ),
                          children: <Widget>[
                            ListTile(
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Mode of transport: $planMode"),
                                  Text("Total persons: $pax"),
                                  Text("Is th plan flexible: $isFlexible"),
                                ],
                              ),
                            )
                          ],
                        ));
                  });
            }

            return CircularProgressIndicator();
          },
        ));
  }
}
