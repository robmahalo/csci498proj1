import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ottov1/home_page.dart';
import 'dart:io';

import 'package:ottov1/login_page.dart';
import 'package:ottov1/register_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'db2',
    options: Platform.isIOS
        ? const FirebaseOptions(
      googleAppID: '1:611857617298:ios:6cec1a28112acb93d4314b',
      gcmSenderID: '611857617298',
      databaseURL: 'https://ottov1-default-rtdb.firebaseio.com',
    )
        : const FirebaseOptions(
      googleAppID: '1:611857617298:android:ca8df1effabdf26cd4314b',
      apiKey: 'AIzaSyDpFO2ztyC2Dve8a6pVpcHKvt-7ClLRB6Y',
      databaseURL: 'https://ottov1-default-rtdb.firebaseio.com',
    )
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: home_page.id,
      routes: {
        register_page.id: (context) => register_page(),
        login_page.id: (context) => login_page(),
        home_page.id: (context) => home_page(),
      },
    );
  }
}