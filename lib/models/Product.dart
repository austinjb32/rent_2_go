import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../pages/components/components/product_review.dart';

class Product {
  final String id;
  final String image;
  final int price;
  final int size;
  final Color color;
  late List<ProductReview> reviews;
  final String title;
  final String description;

  Product({
    required this.id,
    required this.image,
    required this.price,
    required this.size,
    required this.color,
    required this.title,
    required this.description,
    required List<ProductReview> reviews,
  }) : reviews = []; // Initialize reviews as an empty list

  factory Product.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return Product(
      id: snapshot.id,
      title: snapshot.data()!['title'],
      price: snapshot.data()!['price'],
      size: snapshot.data()!['size'],
      description: snapshot.data()!['description'],
      image: snapshot.data()!['image'],
      color: _parseColor(snapshot.data()!['color']),
      reviews: [],
    );
  }

  Future<void> fetchReviews() async {
    try {
      QuerySnapshot<Map<String, dynamic>> reviewsSnapshot =
          await FirebaseFirestore.instance
              .collection('products')
              .doc(id)
              .collection('reviews')
              .get();

      reviews = reviewsSnapshot.docs.map((doc) {
        return ProductReview(
          title: doc.data()['title'],
          description: doc.data()['description'],
        );
      }).toList();
    } catch (error) {
      // Handle error
    }
  }

  static Color _parseColor(String colorString) {
    return Color(int.parse(colorString));
  }
}
