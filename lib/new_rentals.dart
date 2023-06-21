import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/pro.dart' as details;

class UserProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final productsRef = FirebaseFirestore.instance
          .collection('products')
          .where('userId', isEqualTo: user.uid);

      return Scaffold(
        appBar: AppBar(
          title: Text('My Products'),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: productsRef.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final productDocs = snapshot.data!.docs;
              if (productDocs.isNotEmpty) {
                return ListView.builder(
                  itemCount: productDocs.length,
                  itemBuilder: (context, index) {
                    final productData =
                        productDocs[index].data() as Map<String, dynamic>;
                    final product = details.Product(
                      id: productData['id'] ?? '',
                      title: productData['title'] ?? '',
                      price: productData['price'] ?? 0.0,
                      description: productData['description'] ?? '',
                      quantity: productData['quantity'] ?? 0,
                      imageSmall: productData['imageSmall'] ?? '',
                      imageLarge: productData['imageLarge'] ?? '',
                      category: productData['category'] ?? '',
                      userId: productData['userId'] ?? '',
                    );
                    return ListTile(
                      title: Text(product.title),
                      leading: Image(
                        image: NetworkImage(product.imageLarge),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      subtitle: Text("Price: ₹ ${product.price}"),
                      onTap: () {
                        // Handle onTap action
                      },
                    );
                  },
                );
              } else {
                return Center(
                  child: Text("No products found."),
                );
              }
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      );
    } else {
      return Center(
        child: Text("User not logged in."),
      );
    }
  }
}
