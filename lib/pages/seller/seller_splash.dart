import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shoppobae_demo/pages/seller/seller_home_page.dart';
import 'package:shoppobae_demo/pages/seller/seller_info_page.dart';

class SellerSplash extends StatefulWidget {
  const SellerSplash({Key? key}) : super(key: key);

  @override
  State<SellerSplash> createState() => _SellerSplashState();
}

class _SellerSplashState extends State<SellerSplash> {
  late StreamSubscription<DocumentSnapshot> subscription;
  final FirebaseAuth auth = FirebaseAuth.instance;
  late Timer _timer;

  // this function will check if the user data is saved in the seller database or not
  startTimer() {
    _timer = Timer(const Duration(seconds: 1), () async {
      if (auth.currentUser != null) {
        final DocumentReference docRef = FirebaseFirestore.instance
            .collection('sellers')
            .doc(auth.currentUser!.uid);
        subscription = docRef.snapshots().listen((datasnapshot) {
          if (datasnapshot.exists) {
            Fluttertoast.showToast(msg: 'Login Successful');
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const SellerHomePage()));
          } else {
            Fluttertoast.showToast(msg: 'Please Enter Your Details');
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const SellerInfoPage()));
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
    super.dispose();
    _timer.cancel();
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
