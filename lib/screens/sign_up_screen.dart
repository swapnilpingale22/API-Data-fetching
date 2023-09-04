import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final _formKey = GlobalKey<FormState>();

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String textData = '';
  var color = const Color.fromARGB(255, 61, 31, 112);
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> registerUser(String email, String password) async {
    var response = await http.post(
      Uri.parse('https://reqres.in/api/register'),
      body: {
        "email": email,
        "password": password,
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        textData =
            "Registration Successful...!\n Id: ${data['id']} \n Token: ${data['token']}";
        color = const Color.fromARGB(255, 28, 94, 30);
      });
    } else {
      setState(() {
        textData = 'Request Failed...! \n Please check your credentials.';
        color = const Color.fromARGB(255, 161, 14, 4);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.deepPurple,
                ),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an Email Id';
                    }
                    return null;
                  },
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'eg. eve.holt@reqres.in ',
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.deepPurple,
                ),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Password',
                  ),
                ),
              ),
              const SizedBox(height: 60),
              ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    Colors.deepPurpleAccent,
                  ),
                ),
                onPressed: () async {
                  if (emailController.text.isNotEmpty &&
                      passwordController.text.isNotEmpty) {
                    await registerUser(
                      emailController.text.toString(),
                      passwordController.text.toString(),
                    );
                    // ignore: use_build_context_synchronously
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          actions: [
                            OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Close'),
                            ),
                          ],
                          title: const Text('Alert'),
                          content: Text(
                            textData,
                            textAlign: TextAlign.center,
                          ),
                          contentPadding: const EdgeInsets.all(20),
                          backgroundColor: color,
                        );
                      },
                    );
                  } else {
                    ScaffoldMessenger.of(context)
                        // .showMaterialBanner(
                        //   MaterialBanner(
                        //     padding: const EdgeInsets.all(15),
                        //     leading: const Icon(Icons.dangerous_outlined),
                        //     content: const Text('Empty text.'),
                        //     backgroundColor: Colors.red,
                        //     actions: [
                        //       TextButton(
                        //         onPressed: () {
                        //           ScaffoldMessenger.of(context)
                        //               .hideCurrentMaterialBanner();
                        //         },
                        //         child: const Text('Dismiss'),
                        //       ),
                        //     ],
                        //   ),
                        // );
                        .showSnackBar(
                      const SnackBar(
                        content: Text('Empty text.'),
                        backgroundColor: Colors.yellowAccent,
                      ),
                    );
                  }
                },
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
