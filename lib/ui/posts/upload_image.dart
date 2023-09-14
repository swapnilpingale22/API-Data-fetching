import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/toast.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  final storage = FirebaseStorage.instance;
  final dbRef = FirebaseDatabase.instance.ref('Posts');
  File? _image;
  bool isLoading = false;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 60,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      Widgets.showToast('No image selected', Colors.red);
      setState(() {
        _image = null;
      });
    }
  }

  Future uploadImage() async {
    setState(() {
      isLoading = true;
    });
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageRef = FirebaseStorage.instance.ref('/Images/ $id');

    UploadTask uploadTask = storageRef.putFile(_image!.absolute);

    await Future.value(uploadTask).then((value) async {
      var newUrl = await storageRef.getDownloadURL();

      dbRef.child(id).set({
        'Post': newUrl,
        'id': id,
      });
      setState(() {
        isLoading = false;
        _image = null;
      });
      Widgets.showToast('Image Uploaded', Colors.green);
    }).onError((error, stackTrace) {
      setState(() {
        isLoading = false;
      });
      Widgets.showToast(error.toString(), Colors.red);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '📷 Image Upload',
          style: TextStyle(
            color: Colors.lightGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                getImage();
              },
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(35),
                ),
                child: _image == null
                    ? const Icon(
                        CupertinoIcons.photo,
                        size: 70,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(35),
                        child: Image.file(
                          _image!.absolute,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 100),
            OutlinedButton(
              onPressed: () async {
                if (_image != null) {
                  await uploadImage();
                } else {
                  Widgets.showToast('No image selected', Colors.red);
                }
              },
              child: isLoading
                  ? const SizedBox(
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator(),
                    )
                  : const Text(
                      'Upload',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.lightGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
