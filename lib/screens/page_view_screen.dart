import 'package:flutter/material.dart';

import '../ui/auth/post_screen.dart';
import '../ui/firestore/firestore_list_screen.dart';
import '../ui/posts/upload_image.dart';

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const BouncingScrollPhysics(),
        children: [
          const UploadImage(),
          const FirestoreListScreen(),
          PostScreen(),
        ],
      ),
    );
  }
}
