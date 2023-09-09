import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:portfolio_app/ui/auth/verification_screen.dart';
import '../../widgets/toast.dart';

class LoginWithPhone extends StatefulWidget {
  LoginWithPhone({super.key});

  @override
  State<LoginWithPhone> createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends State<LoginWithPhone> {
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  final phoneNumberController = TextEditingController();

  final auth = FirebaseAuth.instance;

  void verifyUser(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    await auth
        .verifyPhoneNumber(
          phoneNumber: "+91${phoneNumberController.text}",
          verificationCompleted: (phoneAuthCredential) {},
          verificationFailed: (error) {
            Widgets.showToast(error, Colors.red);
          },
          codeSent: (verificationId, forceResendingToken) {
            setState(() {
              isLoading = false;
            });
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VerificationScreen(
                    verificationId: verificationId,
                  ),
                ));
          },
          codeAutoRetrievalTimeout: (verificationId) {
            setState(() {
              isLoading = false;
            });
            Widgets.showToast(verificationId, Colors.red);
          },
        )
        .then((value) {})
        .onError((error, stackTrace) {
      setState(() {
        isLoading = false;
      });
      Widgets.showToast(error, Colors.red);
    });
  }

  @override
  void dispose() {
    super.dispose();
    phoneNumberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login with phone number'),
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
                      return 'Please enter a phone number';
                    } else if (value.length == 10) {
                      return null;
                    }
                    return "Enter a valid phone number.";
                  },
                  controller: phoneNumberController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'eg. 999 888 7777',
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
                        'Sign Up',
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
