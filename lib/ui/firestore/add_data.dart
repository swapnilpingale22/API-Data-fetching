import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portfolio_app/widgets/toast.dart';

class AddFirestoreDatascreen extends StatefulWidget {
  const AddFirestoreDatascreen({super.key});

  @override
  State<AddFirestoreDatascreen> createState() => _AddFirestoreDatascreenState();
}

class _AddFirestoreDatascreenState extends State<AddFirestoreDatascreen> {
  final postController = TextEditingController();
  final fireStoreRef = FirebaseFirestore.instance.collection('Users');
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    postController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Firestore Data"),
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
                    setState(() {
                      isLoading = true;
                    });
                    String id =
                        DateTime.now().millisecondsSinceEpoch.toString();
                    await fireStoreRef.doc(id).set({
                      'title': postController.text.toString(),
                      "id": id,
                    }).then((value) {
                      setState(() {
                        isLoading = false;
                      });
                      Widgets.showToast(
                        'Post Added',
                        Colors.green,
                      );
                      Navigator.pop(context);
                    }).onError((error, stackTrace) {
                      setState(() {
                        isLoading = false;
                      });
                      Widgets.showToast(
                        error.toString(),
                        Colors.red,
                      );
                    });
                  } else {
                    Widgets.showToast(
                      'Please enter some text',
                      Colors.red,
                    );
                    postController.clear();
                  }
                },
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    Colors.deepPurple,
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                        ),
                      )
                    : const Text('Add'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
