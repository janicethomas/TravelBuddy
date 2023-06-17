import 'package:flutter/material.dart';
import 'package:mynotes/routes.dart';

class appDrawer extends StatelessWidget {
  const appDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
          child:Container(
              margin:EdgeInsets.only(top:50),
              child:Column(children: <Widget>[

                ListTile(
                    leading:Icon(Icons.home),
                    title: const Text("View Plans"),
                    onTap:(){
                      Navigator.of(context).pushNamed(viewPlansRoute);
                    }
                ),

                ListTile(
                    leading:Icon(Icons.person),
                    title:Text("My Plans"),
                    onTap:(){
                      // My Pfofile button action
                    }
                ),

                ListTile(
                    leading:Icon(Icons.search),
                    title:Text("Find Peoples"),
                    onTap:(){
                      // Find peoples button action
                    }
                )

                //add more drawer menu here

              ],)
          )
      ),
    );
  }
}