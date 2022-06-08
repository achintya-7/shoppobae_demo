import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoppobae_demo/pages/seller/add_product.dart';
import 'package:velocity_x/velocity_x.dart';

class SellerHomePage extends StatefulWidget {
  const SellerHomePage({Key? key}) : super(key: key);

  @override
  State<SellerHomePage> createState() => _SellerHomePageState();
}

class _SellerHomePageState extends State<SellerHomePage> {
  final Stream<QuerySnapshot> _userStream = FirebaseFirestore.instance
      .collection('sellers')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('products')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text('Welcome'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _userStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something Went Wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data == null) {
            return const Text('No Products added');
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return VxBox(
                child: ListTile(
                    isThreeLine: true,
                    title: data['productName']
                        .toString()
                        .text
                        .lg
                        .color(Colors.black)
                        .size(15)
                        .bold
                        .make()
                        .p(8),
                    subtitle: Text(
                      '${data['category']}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ).pOnly(left: 8, bottom: 8),
                    trailing: Text('Rs ${data['price']}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15))
                        .p(8)),
              )
                  .color(Colors.white)
                  .rounded
                  .square(90)
                  .border(color: Colors.black, width: 3)
                  .make()
                  .pOnly(left: 8, right: 8, top: 4, bottom: 4);
            }).toList(),
          ).pOnly(top: 12);
        },
      ),
      floatingActionButton: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.orangeAccent,
        child: IconButton(
          icon: const Icon(Icons.add, color: Colors.black, size: 30),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) => const AddProductPage())));
          },
        ),
      ),
    );
  }
}
