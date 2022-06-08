// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppobae_demo/pages/auth/sign_up.dart';
import 'package:shoppobae_demo/pages/customer/customer_home_page.dart';
import 'package:shoppobae_demo/pages/seller/seller_home_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? seller = prefs.getBool('Seller');
  print(seller);

  runApp(
    MaterialApp(
      home: seller == null // checks if key is avaliable in device memory and bavigates to the appropriate page
          ? const SignUpPage()
          : seller == true
              ? const SellerHomePage()
              : const CustomerHomePage()
    )
  );
}

