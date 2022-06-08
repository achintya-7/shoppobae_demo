// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoppobae_demo/pages/customer/customer_home_page.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomerInfoPage extends StatefulWidget {
  const CustomerInfoPage({Key? key}) : super(key: key);

  @override
  State<CustomerInfoPage> createState() => _CustomerInfoPageState();
}

class _CustomerInfoPageState extends State<CustomerInfoPage> {
  final formGlobalKey2 = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final cityController = TextEditingController();
  final zipController = TextEditingController();
  final emailController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;

  int age = 0;

  DateTime date =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  

  String? dropDownValue = 'Male';
  var items = ['Male', 'Female'];

  bool isEmailValid(String email) => email.contains('@') && email.isNotEmpty;
  bool isZipValid(String zip) => zip.length == 6;
  bool isValid(String value) => value.isNotEmpty;

  addUser() async {
    final CollectionReference colRef =
        FirebaseFirestore.instance.collection('customers');
    await colRef.doc(auth.currentUser!.uid).set({
      'name': nameController.text,
      'email': emailController.text,
      'city': cityController.text,
      'zip': zipController.text,
      'gender': dropDownValue,
      'age': age,
    });

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const CustomerHomePage()));
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
        body: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),
                Form(
                  key: formGlobalKey2,
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
                          controller: zipController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontSize: 16),
                          decoration: const InputDecoration(
                            labelText: "Zip Code",
                            helperText: " ",
                          ),
                          validator: (zip) {
                            if (isZipValid(zip!)) {
                              return null;
                            } else {
                              return 'Zip code must be of 6 digits';
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

                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${date.day}/${date.month}/${date.year}',
                                  style: const TextStyle(fontSize: 24)),
                              IconButton(
                                  onPressed: () async {
                                    DateTime? newDate = await showDatePicker(
                                        context: context,
                                        initialDate: date,
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime.now());
                                    if (newDate == null) {
                                      return;
                                    } else {
                                      age = DateTime.now().year - newDate.year;
                                      date = newDate;
                                      setState(() {});
                                    }
                                  },
                                icon: const Icon(Icons.calendar_month, size: 28)
                              )
                            ]
                        ),

                        const SizedBox(height: 15),

                        ElevatedButton(
                            style: ButtonStyle(
                              enableFeedback: true,
                              overlayColor:
                                MaterialStateProperty.resolveWith((states) {
                                  return states.contains(MaterialState.pressed)
                                      ? Colors.white60
                                      : null;
                                }),

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
                              FocusManager.instance.primaryFocus?.unfocus();
                              if (formGlobalKey2.currentState!.validate()) {
                                formGlobalKey2.currentState!.save();
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
                            )
                        ),

                        const SizedBox(height: 30)
                        
                      ],
                    ).pOnly(left: 10, right: 10, top: 8),
                  ),
                ).pOnly(left: 12, right: 12)
              ],
            ),
          ),
        )
      );
  }
}
