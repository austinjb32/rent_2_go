import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rent_2_go/pages/components/components/product_title_with_image.dart';

import '../../../models/Product.dart';
import 'add_to_cart.dart';
import 'color_and_size.dart';
import 'counter_with_fav_btn.dart';
import 'description.dart';
import 'product_review.dart';

class Body extends StatefulWidget {
  final String productId;

  const Body({Key? key, required this.productId}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Future<Product>? productFuture;

  @override
  void initState() {
    super.initState();
    productFuture = fetchProduct();
  }

  Future<Product> fetchProduct() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('products')
          .doc(widget.productId)
          .get();

      if (snapshot.exists) {
        List<dynamic> reviewList = snapshot.data()!['reviews'] ?? [];
        List<ProductReview> reviews = reviewList.map((reviewData) {
          return ProductReview(
            title: reviewData['title'].toString(),
            description: reviewData['description'].toString(),
          );
        }).toList();

        return Product(
          id: snapshot.id,
          title: snapshot.data()!['title'].toString(),
          price: snapshot.data()!['price'] as int,
          size: snapshot.data()!['size'],
          description: snapshot.data()!['description'].toString(),
          image: snapshot.data()!['image'].toString(),
          color: _parseColor(snapshot.data()!['color'].toString()),
          reviews: reviews,
        );
      }
    } catch (error) {
      // Handle error
    }

    // Return a default product if the fetch fails
    return Product(
      id: '',
      title: '',
      price: 0,
      size: 2,
      description: '',
      image: '',
      color: Colors.black,
      reviews: [],
    );
  }

  static Color _parseColor(String colorString) {
    // Check if the colorString is a valid hexadecimal color representation
    if (colorString.length == 6) {
      return Color(int.parse('FF$colorString', radix: 16));
    }

    // Return a default color if the colorString is invalid
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Product>(
      future: productFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error fetching product data'));
        } else {
          final Product product = snapshot.data!;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.3,
                          ),
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.12,
                            left: kDefaultPadding,
                            right: kDefaultPadding,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                          ),
                          child: Column(
                            children: <Widget>[
                              ColorAndSize(product: product),
                              SizedBox(height: kDefaultPadding / 2),
                              Description(product: product),
                              SizedBox(height: kDefaultPadding / 2),
                              CounterWithFavBtn(),
                              SizedBox(height: kDefaultPadding / 2),
                              AddToCart(product: product),
                              SizedBox(height: kDefaultPadding / 2),
                              Column(
                                children: product.reviews.map((review) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        review.title,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        review.description,
                                        style: TextStyle(
                                          fontSize: 14,
                                          height: 1.5,
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                              SizedBox(height: kDefaultPadding),
                            ],
                          ),
                        ),
                        ProductTitleWithImage(product: product),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

const kDefaultPadding = 16.0;
