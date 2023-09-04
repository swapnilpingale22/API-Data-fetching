// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:portfolio_app/screens/image_upload_screen.dart';
import 'package:portfolio_app/screens/login_firebase.dart';
import 'screens/homepage.dart';
import 'screens/page_2.dart';
import 'screens/sign_up_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      title: "Api Practice",
      home: const Login(),
    );
  }
}
