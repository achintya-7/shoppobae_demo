import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shoppobae_demo/pages/customer/customer_home_page.dart';
import 'package:shoppobae_demo/pages/customer/customer_info_page.dart';

class CustomerSplash extends StatefulWidget {
  const CustomerSplash({Key? key}) : super(key: key);

  @override
  State<CustomerSplash> createState() => _CustomerSplashState();
}

class _CustomerSplashState extends State<CustomerSplash> {
  late StreamSubscription<DocumentSnapshot> subscription;
  final FirebaseAuth auth = FirebaseAuth.instance;
  late Timer _timer;

  // this function will check if the user data is saved in the customer database or not
  startTimer() {
    _timer = Timer(const Duration(seconds: 1), () async {
      if (auth.currentUser != null) {
        final DocumentReference docRef = FirebaseFirestore.instance
            .collection('customers')
            .doc(auth.currentUser!.uid);
        subscription = docRef.snapshots().listen((datasnapshot) {
          if (datasnapshot.exists) {
            Fluttertoast.showToast(msg: 'Login Successful');
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const CustomerHomePage()));
          } else {
            Fluttertoast.showToast(msg: 'Please Enter Your Details');
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const CustomerInfoPage()));
          }
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
