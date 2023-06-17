import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/popup_menu.dart';
import 'package:mynotes/app_drawer.dart';
import 'dart:developer' as devtools show log;

import 'package:mynotes/main.dart';

enum MenuAction { logout }

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
        body: const Text('Hello'));
  }
}
