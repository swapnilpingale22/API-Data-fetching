import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:portfolio_app/ui/auth/login_screen.dart';
import 'package:portfolio_app/widgets/toast.dart';

import '../posts/add_posts.dart';

class PostScreen extends StatelessWidget {
  PostScreen({super.key});
  final auth = FirebaseAuth.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref("Posts");

  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              (user!.email == null)
                  ? const SizedBox()
                  : Text("id: ${user.email.toString()}"),
              (user.phoneNumber == null)
                  ? const SizedBox()
                  : Text("Ph: ${user.phoneNumber.toString()}"),
            ],
          ),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: FirebaseAnimatedList(
              query: ref,
              defaultChild: const Text('Loading...'),
              itemBuilder: (context, snapshot, animation, index) {
                return ListTile(
                  title: Text(
                    snapshot.child('Post').value.toString(),
                  ),
                  subtitle: Text(
                    snapshot.child('id').value.toString(),
                  ),
                );
              },
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddPosts(),
              ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
