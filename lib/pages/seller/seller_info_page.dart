// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoppobae_demo/pages/seller/seller_home_page.dart';
import 'package:velocity_x/velocity_x.dart';

class SellerInfoPage extends StatefulWidget {
  const SellerInfoPage({Key? key}) : super(key: key);

  @override
  State<SellerInfoPage> createState() => _SellerInfoPageState();
}

class _SellerInfoPageState extends State<SellerInfoPage> {
  final formGlobalKey3 = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final cityController = TextEditingController();
  final emailController = TextEditingController();
  final bussinessNameController = TextEditingController();
  final phoneController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;

  String? dropDownValue = 'Electronics';
  var items = ['Electronics', 'Apparels', 'Grocery', 'Other'];

  bool isEmailValid(String email) => email.contains('@') && email.isNotEmpty;
  bool isPhoneValid(String phone) => phone.length == 10;
  bool isValid(String value) => value.isNotEmpty;

  addUser() async {
    final CollectionReference colRef =
        FirebaseFirestore.instance.collection('sellers');
    await colRef.doc(auth.currentUser!.uid).set({
      'name': nameController.text,
      'email': emailController.text,
      'city': cityController.text,
      'phone': phoneController.text,
      'category': dropDownValue,
    });

    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const SellerHomePage()));
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
        body: Stack(
          children: 
            [Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Form(
                      key: formGlobalKey3,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(color: Colors.black, blurRadius: 7)
                            ]),
                        child: Column(
                          children: [
                            TextFormField(
                              maxLines: 1,
                              style: const TextStyle(fontSize: 16),
                              controller: nameController,
                              decoration: const InputDecoration(
                                labelText: "Name",
                                helperText: " ",
                              ),
                              validator: (value) {
                                if (isValid(value!)) {
                                  return null;
                                } else {
                                  return 'Please enter the field';
                                }
                              },
                            ),
                            TextFormField(
                              controller: emailController,
                              style: const TextStyle(fontSize: 16),
                              decoration: const InputDecoration(
                                labelText: "Email",
                                helperText: " ",
                              ),
                              validator: (email) {
                                if (isEmailValid(email!)) {
                                  return null;
                                } else {
                                  return 'Please enter a valid email';
                                }
                              },
                            ),
                            TextFormField(
                              controller: cityController,
                              style: const TextStyle(fontSize: 16),
                              decoration: const InputDecoration(
                                labelText: "City",
                                helperText: " ",
                              ),
                              validator: (value) {
                                if (isValid(value!)) {
                                  return null;
                                } else {
                                  return 'Please enter the field';
                                }
                              },
                            ),
                            TextFormField(
                              maxLines: 1,
                              style: const TextStyle(fontSize: 16),
                              controller: bussinessNameController,
                              decoration: const InputDecoration(
                                labelText: "Bussiness Name",
                                helperText: " ",
                              ),
                              validator: (value) {
                                if (isValid(value!)) {
                                  return null;
                                } else {
                                  return 'Please enter the field';
                                }
                              },
                            ),
                            TextFormField(
                              maxLength: 10,
                              controller: phoneController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(fontSize: 16),
                              decoration: const InputDecoration(
                                labelText: "Phone Number",
                                helperText: " ",
                              ),
                              validator: (phone) {
                                if (isPhoneValid(phone!)) {
                                  return null;
                                } else {
                                  return 'Phone Number must be of 10 digits';
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
                              onChanged: (val) =>
                                  setState(() => dropDownValue = val as String?),
                            ),

                            const SizedBox(height: 30),
                            
                            ElevatedButton(
                                style: ButtonStyle(
                                    enableFeedback: true,
                                    overlayColor:
                                        MaterialStateProperty.resolveWith((states) {
                                      return states.contains(MaterialState.pressed)
                                          ? Colors.white60
                                          : null;
                                    }),
                                    fixedSize: MaterialStateProperty.all(
                                        const Size(200, 45)),
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color.fromARGB(204, 46, 247, 20)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(32),
                                            side: const BorderSide(
                                                color: Colors.black, width: 3)))),
                                onPressed: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
        
                                  if (formGlobalKey3.currentState!.validate()) {
                                    formGlobalKey3.currentState!.save();
                                    addUser();
                                  }
                                },
                                child: const Text(
                                  'Register',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                            const SizedBox(height: 30)
                          ],
                        ).pOnly(left: 10, right: 10, top: 8),
                      ),
                    ).pOnly(left: 12, right: 12)
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
