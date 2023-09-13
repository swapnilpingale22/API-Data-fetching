import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:portfolio_app/ui/auth/login_screen.dart';
import 'package:portfolio_app/widgets/toast.dart';
import 'add_data.dart';

class FirestoreListScreen extends StatefulWidget {
  const FirestoreListScreen({super.key});

  @override
  State<FirestoreListScreen> createState() => _FirestoreListScreenState();
}

class _FirestoreListScreenState extends State<FirestoreListScreen> {
  final auth = FirebaseAuth.instance;
  final updateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore'),
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
                    Navigator.pushReplacement(
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
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return const ListTile(
                    title: Text('Title'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddFirestoreDatascreen(),
              ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
