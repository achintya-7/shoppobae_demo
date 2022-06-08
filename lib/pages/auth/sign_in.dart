// ignore_for_file: use_build_context_synchronously, avoid_print, prefer_interpolation_to_compose_strings

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppobae_demo/pages/auth/sign_up.dart';
import 'package:shoppobae_demo/pages/customer/customer_splash.dart';
import 'package:shoppobae_demo/pages/seller/seller_splash.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final formGlobalKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final navigatorKey = GlobalKey<NavigatorState>();

  String? dropDownValue = 'Customer';
  var items = ['Customer', 'Seller'];

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool isEmailValid(String email) => email.contains('@') && email.isNotEmpty;
  bool isPasswordValid(String password) => password.length >= 6;

  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());

      // if the user selectes seller, saves his/her selection in device memory
      // and naviagates to the Seller's Home Page
      if (dropDownValue == 'Seller') {
        final prefs = await SharedPreferences.getInstance();
        try {
          await prefs.setBool('Seller', true);
        } catch (e) {
          print('key error' + e.toString());
        }
        Navigator.push(context,
            MaterialPageRoute(builder: ((context) => const SellerSplash())));
      }

      // if the user selectes customer, saves his/her selection in device memory
      // and naviagates to the Seller's Home Page
      else {
        final prefs = await SharedPreferences.getInstance();
        try {
          await prefs.setBool('Seller', false);
        } catch (e) {
          print('key error' + e.toString());
        }
        Navigator.push(context,
            MaterialPageRoute(builder: ((context) => const CustomerSplash())));
      }
    } catch (e) {
      // if something goes wrong
      Fluttertoast.showToast(
        msg:
            "Something went wrong, Please check your Email and Password. Also ${e.toString()}",
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
          title: const Text('Sign In'),
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
                            ]),
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

                            DropdownButtonFormField(
                              value: dropDownValue,
                              items: items.map((item) {
                                return DropdownMenuItem(
                                  value: item,
                                  child: Text(item),
                                );
                              }).toList(),
                              onChanged: (val) => setState(
                                  () => dropDownValue = val as String?),
                            ),
                            
                            ElevatedButton(
                                style: ButtonStyle(
                                    enableFeedback: true,
                                    overlayColor:
                                        MaterialStateProperty.resolveWith(
                                          (states) {
                                            return states.contains(MaterialState.pressed) ? Colors.white60 : null;
                                          }
                                        ),
                                    fixedSize: MaterialStateProperty.all(const Size(200, 45)),
                                    backgroundColor: MaterialStateProperty.all(const Color.fromARGB(204, 46, 247, 20)),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder( 
                                        borderRadius: BorderRadius.circular(32),
                                        side: const BorderSide(color: Colors.black, width: 3)
                                      )
                                    )
                                ),
                                onPressed: () {
                                  // pulls down the keyboard and removes focus node from text field
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  if (formGlobalKey.currentState!.validate()) {
                                    formGlobalKey.currentState!.save();
                                    signIn();
                                  }
                                },
                                child: const Text(
                                  'Sign In',
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
                                  MaterialPageRoute(builder: (context) => const SignUpPage())
                                );
                              },
                              child: const Text(
                                  'Do not have an account. Click Here!'
                              ),
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
        ).centered()
      );
  }
}
