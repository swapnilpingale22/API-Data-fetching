import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:portfolio_app/ui/auth/login_screen.dart';
import 'package:portfolio_app/widgets/toast.dart';

import '../posts/add_posts.dart';

class PostScreen extends StatefulWidget {
  PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;

  DatabaseReference ref = FirebaseDatabase.instance.ref("Posts");

  final searchController = TextEditingController();
  final updateController = TextEditingController();

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
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 5,
              ),
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        15,
                      ),
                    ),
                  ),
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
            const Divider(),
            Expanded(
              child: FirebaseAnimatedList(
                query: ref,
                defaultChild: const Text('Loading...'),
                itemBuilder: (context, snapshot, animation, index) {
                  final title = snapshot.child('Post').value.toString();
                  final id = snapshot.child('id').value.toString();
                  if (searchController.text.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        tileColor: Colors.blueGrey,
                        title: Text(title),
                        subtitle: Text(id),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 1,
                              child: ListTile(
                                onTap: () {
                                  Navigator.pop(context);
                                  showEditBox(title, id);
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
                                  await ref
                                      .child(id)
                                      .remove()
                                      .then((value) => Widgets.showToast(
                                          'Deleted', Colors.green))
                                      .onError((error, stackTrace) =>
                                          Widgets.showToast(
                                              error.toString(), Colors.red));
                                },
                                leading: const Icon(Icons.delete),
                                title: const Text('Delete'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (title
                      .toLowerCase()
                      .contains(searchController.text.toLowerCase())) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        tileColor: Colors.blueGrey,
                        title: Text(title),
                        subtitle: Text(id),
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const AddPosts(),
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
          content: Container(
            child: TextField(
              controller: updateController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
            ),
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
                await ref
                    .child(id)
                    .update({'Post': updateController.text})
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



      //  Expanded(
      //         child: StreamBuilder(
      //           stream: FirebaseDatabase.instance.ref().child('Posts').onValue,
      //           builder: (BuildContext context,
      //               AsyncSnapshot<DatabaseEvent> snapshot) {
      //             if (snapshot.hasData) {
      //               Map<dynamic, dynamic>? data =
      //                   snapshot.data!.snapshot.value as Map<dynamic, dynamic>?;

      //               if (data != null) {
      //                 return ListView.builder(
      //                   itemCount: data.length,
      //                   itemBuilder: (context, index) {
      //                     var postId = data.keys.toList()[index];
      //                     var post = data[postId];

      //                     // Access individual properties
      //                     var id = post['id'];
      //                     var content = post['Post'];

      //                     return ListTile(
      //                       title: Text(content),
      //                       subtitle: Text(id),
      //                     );
      //                   },
      //                 );
      //               } else {
      //                 return const Text('No posts available.');
      //               }
      //             } else if (snapshot.hasError) {
      //               return Text('Error: ${snapshot.error}');
      //             } else {
      //               return const Center(child: CircularProgressIndicator());
      //             }
      //           },
      //         ),
      //       ),