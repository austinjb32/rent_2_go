import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rent_2_go/favourites.dart';
import 'package:rent_2_go/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rent_2_go/screens/search/search_widget.dart';

import '../../constants.dart';
import '../../models/pro.dart';
import 'components/categories.dart';
import 'new_arrival_page.dart';

class HomeScreen extends StatefulWidget {
  final bool isAuthenticated;

  const HomeScreen({Key? key, required this.isAuthenticated}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Stream<QuerySnapshot> productStream = FirebaseFirestore.instance
      .collection('products')
      .snapshots(); // Replace 'products' with your collection name

  int selectedCategoryIndex = 0;

  Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isAuthenticated) {
      return LoginPage();
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            // Open menu or perform desired action
          },
          icon: SvgPicture.asset("assets/icons/menu.svg"),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset("assets/icons/search.svg"),
            color: Colors.redAccent,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => (SearchPage())),
              );
            },
          ),
          IconButton(
            icon: SvgPicture.asset("assets/icons/back.svg"),
            onPressed: () {
              signOut(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Rent2Go",
              style: Theme.of(context).textTheme.headline4!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
            ),
            const Text(
              "Rentals",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: defaultPadding),
            Categories(
              categories: demoCategories,
              onCategorySelected: (categoryIndex) {
                setState(() {
                  selectedCategoryIndex = categoryIndex;
                });
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: StreamBuilder<QuerySnapshot>(
                stream: productStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    // Handle error state
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Handle loading state
                    return CircularProgressIndicator();
                  }

                  // Data has been fetched successfully
                  final products = snapshot.data?.docs;

                  // Filter products by selected category
                  final filteredProducts = (products ?? []).where((product) {
                    final productCategory = product.get('category') as String;
                    return productCategory ==
                        demoCategories[selectedCategoryIndex].title;
                  }).toList();

                  // Update your UI with the fetched and filtered products
                  return NewArrivalPage(
                    selectedCategoryIndex: selectedCategoryIndex,
                    products: filteredProducts,
                  );
                },
              ),
            ),
            // Add your other widgets here
          ],
        ),
      ),
    );
  }
}
