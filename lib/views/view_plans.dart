import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mynotes/popup_menu.dart';
import 'package:mynotes/app_drawer.dart';
import 'package:mynotes/globals.dart' as globals;
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
  final CollectionReference _refUsers =
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

  // Future<String> getCreatorName (String ownerId) async{
  //   DocumentSnapshot docSnapshot = await _refUsers.doc(ownerId).get();
  //   devtools.log(ownerId + (docSnapshot.data() as Map<String, dynamic>)['user_name']);
  //   if (docSnapshot.exists) {
  //     final data = docSnapshot.data() as Map<String, dynamic>;
  //     return data['user_name'];
  //   }
  //   else {
  //     return "abc";
  //   }
  // }
  //
  // Widget ownerWidget(String ownerId) {
  //   return FutureBuilder(
  //       future: getCreatorName(ownerId),
  //       builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
  //         switch (snapshot.connectionState) {
  //           case ConnectionState.none: return new Text('Press button to start');
  //           case ConnectionState.waiting: return new Text('Awaiting result...');
  //           default:
  //             if (snapshot.hasError)
  //               return new Text('Owner not found');
  //             else
  //               return new Text('Plan created by: ${snapshot.data}');
  //         }
  //       }
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
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
              return ListView.builder (
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
                    final ownerId = docSnapshot['plan_created_by'];

                    // late final creator = getCreatorName(ownerId);

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
                                  Text("${globals.userName}"),
                                  Text("Mode of transport: $planMode"),
                                  Text("Total persons: $pax"),
                                  Text("Is the plan flexible: $isFlexible"),
                                ],
                              ),
                            )
                          ],
                        )
                    );
                  });
            }

            return CircularProgressIndicator();
          },
        ));
  }
}

// StreamBuilder (
// stream: _streamUsers,
// builder: (userContext, userSnapshot) {
// if (userSnapshot.connectionState == ConnectionState.active) {
// QuerySnapshot? userQuerySnapshot = userSnapshot.data;
// final DocumentSnapshot userDocSnapshot =
// userQuerySnapshot!.docs[owner];
// final creater = userDocSnapshot['user_name'];
// }
// },
// );
