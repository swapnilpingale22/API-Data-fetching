import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:portfolio_app/ui/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      title: "Api Practice",
      home: SplashScreen(),
      //  PageView(
      //   physics: const BouncingScrollPhysics(),
      //   children: const [
      //     Login(),
      //     Homepage(),
      //     ImageUploadScreen(),
      //     SecondPage(),
      //     SignUpScreen(),
      //   ],
      // ),
    );
  }
}
