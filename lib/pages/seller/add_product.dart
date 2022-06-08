// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:velocity_x/velocity_x.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({Key? key}) : super(key: key);

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final formGlobalKey4 = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final brandController = TextEditingController();
  final priceController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;

  String? dropDownValue = 'Electronics';
  var items = ['Electronics', 'Apparels', 'Grocery', 'Other'];

  bool isValid(String value) => value.isNotEmpty;

  // stores data in seller's personal collection and an overall product collection for users.
  addProducts() async {
    try {
      final CollectionReference colRef =
          FirebaseFirestore.instance.collection('products');
      await colRef.doc().set({
        'productName': nameController.text,
        'brand': brandController.text,
        'price': int.parse(priceController.text),
        'category': dropDownValue,
        'seller': auth.currentUser!.email,
        'sellerId': auth.currentUser!.uid
      });

      final CollectionReference docRef = FirebaseFirestore.instance
          .collection('sellers')
          .doc(auth.currentUser!.uid)
          .collection('products');

      await docRef.doc().set({
        'productName': nameController.text,
        'brand': brandController.text,
        'price': int.parse(priceController.text),
        'category': dropDownValue,
      });

      Fluttertoast.showToast(msg: 'Products added');
      nameController.clear();
      brandController.clear();
      priceController.clear();

      Navigator.pop(context);
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: 'Something Went Wrong. Also ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new product'),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Form(
                key: formGlobalKey4,
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
                          labelText: "Name of Product",
                          helperText: " ",
                        ),
                        validator: (value) {
                          if (isValid(value!)) {
                            return null;
                          } else {
                            return 'Please enter this field';
                          }
                        },
                      ),
                      TextFormField(
                        maxLines: 1,
                        style: const TextStyle(fontSize: 16),
                        controller: brandController,
                        decoration: const InputDecoration(
                          labelText: "Brand",
                          helperText: " ",
                        ),
                        validator: (value) {
                          if (isValid(value!)) {
                            return null;
                          } else {
                            return 'Please enter this field';
                          }
                        },
                      ),
                      TextFormField(
                        maxLines: 1,
                        style: const TextStyle(fontSize: 16),
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Price",
                          helperText: " ",
                        ),
                        validator: (value) {
                          if (isValid(value!)) {
                            return null;
                          } else {
                            return 'Please enter this field';
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

                            if (formGlobalKey4.currentState!.validate()) {
                              FocusScope.of(context).unfocus();
                              formGlobalKey4.currentState!.save();
                              addProducts();
                            }
                          },
                          child: const Text(
                            'Add Product',
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
    );
  }
}
