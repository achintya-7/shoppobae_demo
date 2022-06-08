// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shoppobae_demo/pages/auth/sign_in.dart';
import 'package:velocity_x/velocity_x.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formGlobalKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool isEmailValid(String email) => email.contains('@') && email.isNotEmpty;
  bool isPasswordValid(String password) => password.length >= 6;

  Future signUp() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());

      Fluttertoast.showToast(msg: 'User added, Pls Sign In');

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const SignInPage()));
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Something went wrong, Please check your Email and Password",
        toastLength: Toast.LENGTH_LONG,
      );
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        resizeToAvoidBottomInset: true,

        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          title: const Text('Sign Up'),
        ),

        body: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [

              Column(
                
                children: [
                  const SizedBox(height: 30),
                  Form(
                      key: formGlobalKey,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(color: Colors.black, blurRadius: 7)
                          ]
                        ),
                        child: Column(
                          children: [

                            const SizedBox(height: 30),
                            
                            TextFormField(
                              maxLines: 1,
                              style: const TextStyle(fontSize: 18),
                              controller: emailController,
                              decoration: const InputDecoration(
                                labelText: "Email",
                                helperText: " ",
                              ),
                              validator: (email) {
                                if (isEmailValid(email!)) {
                                  return null;
                                } else {
                                  return 'Enter a valid email address';
                                }
                              },
                            ),

                            TextFormField(
                              controller: passwordController,
                              style: const TextStyle(fontSize: 18),
                              decoration: const InputDecoration(
                                labelText: "Password",
                                helperText: " ",
                              ),
                              obscureText: true,
                              validator: (password) {
                                if (isPasswordValid(password!)) {
                                  return null;
                                } else {
                                  return 'Password has more than 6 charectors';
                                }
                              },
                            ),

                            ElevatedButton(
                                style: ButtonStyle(
                                    enableFeedback: true,
                                    overlayColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) {
                                      return states
                                              .contains(MaterialState.pressed)
                                          ? Colors.white60
                                          : null;
                                    }),
                                    fixedSize: MaterialStateProperty.all(const Size(200, 45)),

                                    backgroundColor: MaterialStateProperty.all(
                                        const Color.fromARGB(204, 46, 247, 20)),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(32),
                                            side: const BorderSide(color: Colors.black, width: 3)
                                          )
                                        )
                                ),
                                onPressed: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  if (formGlobalKey.currentState!.validate()) {
                                    formGlobalKey.currentState!.save();
                                    signUp();
                                  }
                                },

                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                            ).pOnly(top: 12, bottom: 12),

                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const SignInPage()));
                              },

                              child: const Text(
                                  'Already have an account. Click Here!'),
                            ),

                            const SizedBox(height: 30)

                          ],
                        ).pOnly(left: 8, right: 8, top: 10),
                      )
                    ),
                ],
              ),
            ],
          ),
        ).centered());
  }
}
