// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'screens/homepage.dart';
import 'screens/page_2.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      title: "Api Practice",
      home: const SecondPage(),
    );
  }
}
