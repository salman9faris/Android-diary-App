import 'package:diary/login/emaillogin.dart';
import 'package:diary/screen/home.dart';
import 'package:diary/screen/home2.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _initialization = Firebase.initializeApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primaryColor: Color(0xff2b6673),
              //primarySwatch:Color(0xffC0EECE),
            ),
            home: Homepage(),
          );
        });
  }
}
