import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:portfolio_app/ui/auth/login_screen.dart';
import 'package:portfolio_app/widgets/toast.dart';

class PostScreen extends StatelessWidget {
  PostScreen({super.key});
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: IconButton(
              onPressed: () async {
                await auth.signOut().then(
                  (value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Login(),
                      ),
                    );
                  },
                ).onError(
                  (error, stackTrace) {
                    Widgets.showToast(error.toString(), Colors.red);
                  },
                );
              },
              icon: const Icon(Icons.logout),
            ),
          )
        ],
      ),
    );
  }
}
