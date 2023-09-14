import 'package:cloud_firestore/cloud_firestore.dart';
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
  final fireStoreStream =
      FirebaseFirestore.instance.collection('Users').snapshots();
  CollectionReference fireStoreRef =
      FirebaseFirestore.instance.collection('Users');
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '🔥 Firestore',
          style: TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
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
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: fireStoreStream,
                builder: (context, snapshot) {
                  //
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Text('Some error occured');
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                          child: ListTile(
                            title: Text(
                                '${index + 1}.  ${snapshot.data!.docs[index]['title']}'),
                            subtitle: Text(snapshot.data!.docs[index]['id']),
                            trailing: PopupMenuButton(
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 1,
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.pop(context);
                                      showEditBox(
                                        snapshot.data!.docs[index]['title'],
                                        snapshot.data!.docs[index]['id'],
                                      );
                                    },
                                    leading: const Icon(Icons.edit),
                                    title: const Text('Edit'),
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 2,
                                  child: ListTile(
                                    onTap: () async {
                                      Navigator.pop(context);
                                      await fireStoreRef
                                          .doc(snapshot.data!.docs[index]['id'])
                                          .delete()
                                          .then((value) => Widgets.showToast(
                                              'Deleted', Colors.green))
                                          .onError((error, stackTrace) =>
                                              Widgets.showToast(
                                                  error.toString(),
                                                  Colors.red));
                                    },
                                    leading: const Icon(Icons.delete),
                                    title: const Text('Delete'),
                                  ),
                                ),
                              ],
                            ),
                            tileColor: Colors.brown,
                            shape: const Border(
                              left: BorderSide(
                                color: Colors.white,
                              ),
                              right: BorderSide(
                                color: Colors.white,
                              ),
                              top: BorderSide(
                                color: Colors.white,
                              ),
                              bottom: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return const Text('No data found');
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

  Future<void> showEditBox(title, id) async {
    updateController.text = title;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update'),
          content: TextField(
            controller: updateController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
            onSubmitted: (value) async {
              Navigator.pop(context);
              await fireStoreRef
                  .doc(id)
                  .update({'title': updateController.text})
                  .then((value) =>
                      Widgets.showToast('Post Updated', Colors.green))
                  .onError((error, stackTrace) =>
                      Widgets.showToast(error.toString(), Colors.red));
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await fireStoreRef
                    .doc(id)
                    .update({'title': updateController.text})
                    .then((value) =>
                        Widgets.showToast('Post Updated', Colors.green))
                    .onError((error, stackTrace) =>
                        Widgets.showToast(error.toString(), Colors.red));
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
