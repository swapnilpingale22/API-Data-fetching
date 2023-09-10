import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:portfolio_app/widgets/toast.dart';

import '../auth/post_screen.dart';

class AddPosts extends StatefulWidget {
  const AddPosts({super.key});

  @override
  State<AddPosts> createState() => _AddPostsState();
}

class _AddPostsState extends State<AddPosts> {
  bool isLoading = false;
  final postController = TextEditingController();
  // final databaseRef = FirebaseDatabase.instance.ref('Post');
  // Write a message to the database
  // FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref("Posts");

  @override
  void dispose() {
    super.dispose();
    postController.dispose();
  }

  Future addPost() async {
    try {
      await ref
          .child(
        DateTime.now().millisecondsSinceEpoch.toString(),
      )
          .set({
        "Post": postController.text.toString(),
        "id": DateTime.now().millisecondsSinceEpoch.toString(),
      }).then((value) {
        Widgets.showToast(
          "Post Added",
          Colors.green,
        );
        postController.clear();
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostScreen(),
            ));
      });
    } catch (e) {
      Widgets.showToast(
        e.toString(),
        Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Post"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: postController,
                maxLines: 4,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  hintText: 'Write something',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.deepPurpleAccent,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  if (postController.text.trim().isNotEmpty) {
                    await addPost();
                  } else {
                    Widgets.showToast('Please enter some text', Colors.red);
                    postController.clear();
                  }
                },
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    Colors.deepPurple,
                  ),
                ),
                child: const Text('Add'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
