import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class AddToProductPage extends StatefulWidget {
  final String userId;

  const AddToProductPage({required this.userId});

  @override
  _AddToProductPageState createState() => _AddToProductPageState();
}

class _AddToProductPageState extends State<AddToProductPage> {
  File? _image;
  TextEditingController _productController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User ID: ${widget.userId}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 150,
                height: 150,
                color: Colors.grey[200],
                child: _image != null
                    ? Image.file(
                        _image!,
                        fit: BoxFit.cover,
                      )
                    : Icon(Icons.add_a_photo),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _productController,
              decoration: InputDecoration(
                labelText: 'Product Name',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Price',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                String productName = _productController.text.trim();
                String price = _priceController.text.trim();
                String description = _descriptionController.text.trim();

                if (_image != null &&
                    productName.isNotEmpty &&
                    price.isNotEmpty &&
                    description.isNotEmpty) {
                  _uploadImage(productName, int.parse(price), description);
                  _productController.clear();
                  _priceController.clear();
                  _descriptionController.clear();
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text(
                            'Please provide an image, product name, price, and description'),
                        actions: [
                          ElevatedButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> _uploadImage(
      String productName, int price, String description) async {
    try {
      if (_image != null) {
        firebase_storage.Reference ref =
            firebase_storage.FirebaseStorage.instance.ref().child(
                'product_images/${widget.userId}_${DateTime.now().millisecondsSinceEpoch}.jpg');
        await ref.putFile(_image!);

        String imageURL = await ref.getDownloadURL();

        await FirebaseFirestore.instance.collection('products').add({
          'user_id': widget.userId,
          'product_name': productName,
          'price': price,
          'description': description,
          'image_url': imageURL,
        });

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Product added successfully'),
              actions: [
                ElevatedButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to add product'),
            actions: [
              ElevatedButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
