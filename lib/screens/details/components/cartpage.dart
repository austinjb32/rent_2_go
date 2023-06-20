import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartProduct {
  final String productId;
  final int quantity;

  CartProduct({
    required this.productId,
    required this.quantity,
  });
}

class Product {
  final String productId;
  final String name;
  final int price;
  final String imageUrl;

  Product({
    required this.productId,
    required this.name,
    required this.price,
    required this.imageUrl,
  });
}

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CollectionReference cartCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference productCollection =
      FirebaseFirestore.instance.collection('products');

  List<CartProduct> cartProducts = [];
  List<Product> fetchedProducts = [];

  @override
  void initState() {
    super.initState();
    fetchCartProducts();
  }

  Future<void> fetchCartProducts() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final cartRef = cartCollection.doc(user.uid).collection('cart');
      final cartSnapshot = await cartRef.get();

      final List<CartProduct> fetchedCartProducts = [];
      for (final doc in cartSnapshot.docs) {
        final productId = doc.id;
        final quantity = doc.data()['quantity'] ?? 0;

        fetchedCartProducts.add(
          CartProduct(productId: productId, quantity: quantity),
        );
      }

      setState(() {
        cartProducts = fetchedCartProducts;
      });

      final List<Product> fetchedProductInfo = [];
      for (final cartProduct in cartProducts) {
        final productDoc =
            await productCollection.doc(cartProduct.productId).get();
        if (productDoc.exists) {
          final productData = productDoc.data() as Map<String, dynamic>?;

          final product = Product(
            productId: productDoc.id,
            name: productData?['title'] as String? ?? '',
            price: productData?['price'] ?? 0,
            imageUrl: productData?['imageSmall'] as String? ?? '',
          );
          fetchedProductInfo.add(product);
        }
      }

      setState(() {
        fetchedProducts = fetchedProductInfo;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Your Orders",
          textScaleFactor: 1.5,
        ),
      ),
      body: cartProducts.isEmpty
          ? const Center(
              child: Text('No items found in the cart.'),
            )
          : Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: fetchedProducts.length,
                    itemBuilder: (context, index) {
                      final cartProduct = cartProducts[index];
                      final product = fetchedProducts[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          leading: Image.network(
                            product.imageUrl,
                            width: 75,
                            height: 75,
                            fit: BoxFit.cover,
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  'Product ID: ${product.productId}',
                                  textScaleFactor: 0.5,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  '${product.name}',
                                  textScaleFactor: 2,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text('Quantity: ${cartProduct.quantity}'),
                          trailing: Text(
                            'INR ${product.price}',
                            textScaleFactor: 2,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
