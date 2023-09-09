import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:portfolio_app/ui/auth/post_screen.dart';
import '../../widgets/toast.dart';

class VerificationScreen extends StatefulWidget {
  final String verificationId;
  const VerificationScreen({super.key, required this.verificationId});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  final codeController = TextEditingController();

  final auth = FirebaseAuth.instance;

  void verifyUser(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    final authCredentials = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: codeController.text.toString(),
    );

    try {
      await auth.signInWithCredential(authCredentials).then((value) {
        setState(() {
          isLoading = false;
        });
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostScreen(),
            ));
        Widgets.showToast('Success', Colors.green);
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Widgets.showToast(e.toString(), Colors.red);
    }
  }

  @override
  void dispose() {
    super.dispose();
    codeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify your phone'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
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
                      return 'Please enter your verification code';
                    } else if (value.length == 6) {
                      return null;
                    }
                    return 'Enter a valid 6 digit code';
                  },
                  controller: codeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter your code',
                    prefixIcon: Icon(Icons.phone_iphone),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    Colors.deepPurpleAccent,
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    verifyUser(context);
                  }
                },
                child: isLoading
                    ? const SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : const Text(
                        'Validate',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
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
