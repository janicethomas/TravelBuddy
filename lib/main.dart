import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/register_view.dart';

import 'firebase_options.dart';

void test() {
  print('check');
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // test();
  runApp(MyApp());
  // runApp(MaterialApp(
  //   title: 'Flutter Demo',
  //   theme: ThemeData(
  //     colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
  //     useMaterial3: true,
  //   ),
  //   home: const MyHomePage(title: 'Flutter Demo Home Page'),
  // ), );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            color: Colors.teal[200],
          )),
      home: const HomePage(),
      routes: {
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            print(FirebaseAuth.instance.currentUser);
            // final user = FirebaseAuth.instance.currentUser;
            // if (user?.emailVerified ?? false) {
            //   // print("You are a verified user,");
            //   // print(user);
            //   return const LoginView();
            // } else {
            //   print("You need to verify your user first.");
            //   // Future.delayed(Duration.zero, () {
            //   //   Navigator.of(context).push(MaterialPageRoute(
            //   //       builder: (context) => const VerifyEmailView()));
            //   // });
            //   return const VerifyEmailView();
            return const LoginView();
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}



// Default Home Page
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//
//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       appBar: AppBar(
//
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               "You have pushed the button this many times:",
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
