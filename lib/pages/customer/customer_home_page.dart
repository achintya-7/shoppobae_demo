import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({Key? key}) : super(key: key);

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  final searchController = TextEditingController();
  final Stream<QuerySnapshot> _productStream =
      FirebaseFirestore.instance.collection('products').snapshots();

  String? dropDownValue = 'Electronics';
  var items = ['Electronics', 'Apparels', 'Grocery', 'Other'];

  bool usingFilter = false;
  bool sort = false;
  bool descending = false;

  late Stream<QuerySnapshot> _filterStream;

  searchProduct() {
    // if we are using filter and are not sorting prices
    if (usingFilter == true && sort == false) {
      _filterStream = FirebaseFirestore.instance
          .collection('products')
          .where('category', isEqualTo: dropDownValue)
          .snapshots();
    }
    // if we are using filter and are sorting prices in ascending order
    if (sort == true && descending == false && usingFilter == true) {
      _filterStream = FirebaseFirestore.instance
          .collection('products')
          .orderBy('price', descending: false)
          .snapshots();
    }
    // if we are using filter and are not sorting prices in descending order
    if (sort == true && descending == true) {
      _filterStream = FirebaseFirestore.instance
          .collection('products')
          .orderBy('price', descending: true)
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text('Welcome'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 8),
            child: DropdownButtonFormField(
                value: dropDownValue,
                style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                items: items.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (val) {
                  sort = false;
                  usingFilter = true;
                  dropDownValue = val as String?;
                  searchProduct();
                  setState(() {});
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              ElevatedButton(
                style: ButtonStyle(
                      enableFeedback: true,
                      overlayColor: MaterialStateProperty.resolveWith((states) {
                        return states.contains(MaterialState.pressed)
                            ? Colors.yellow
                            : null;
                      }),
                      fixedSize: MaterialStateProperty.all(const Size(150, 45)),
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                              side: const BorderSide(
                                  color: Colors.black, width: 3)
                          )
                      )
                    ),
                  onPressed: () {
                    usingFilter = true;
                    sort = true;
                    descending = true;
                    searchProduct();
                    setState(() {});
                  },
                  child: const Text('High to Low', style: TextStyle(color: Colors.black, fontSize: 15))),

              ElevatedButton(
                  style: ButtonStyle(
                      enableFeedback: true,
                      overlayColor: MaterialStateProperty.resolveWith((states) {
                        return states.contains(MaterialState.pressed)
                            ? Colors.green
                            : null;
                      }),
                      fixedSize: MaterialStateProperty.all(const Size(150, 45)),
                      backgroundColor: MaterialStateProperty.all(
                        Colors.white
                       ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                              side: const BorderSide(
                                  color: Colors.black, width: 3)
                          )
                      )
                  ),
                  onPressed: () {
                    usingFilter = true;
                    sort = true;
                    descending = false;
                    searchProduct();
                    setState(() {});
                  },
                  child: const Text('Low to High', style: TextStyle(color: Colors.black, fontSize: 15)))
            ],
          ).pOnly(bottom: 8, top: 4),
          StreamBuilder<QuerySnapshot>(
            stream: usingFilter ? _filterStream : _productStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                const Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.data == null) {
                return const Center(child: Text('No Products added'));
              }
              return Expanded(
                child: ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return VxBox(
                      child: ListTile(
                          isThreeLine: true,
                          title: data['brand'].toString().text.lg.color(Colors.black).size(15).bold.make().p(8),

                          subtitle: Text(
                            '${data['productName']}\n${data['seller']}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ).pOnly(left: 8, bottom: 8),

                          trailing: 
                            Text(
                              'Rs ${data['price']}',
                                  style: const TextStyle
                                  (
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15
                                  )
                              ).p(8)
                          ),
                    ).color(Colors.white).rounded.square(90).border(color: Colors.black, width: 3).make().pOnly(left: 8, right: 8, top: 4, bottom: 4);
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
