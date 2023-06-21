import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:rent_2_go/add_products.dart';
import 'package:rent_2_go/constants.dart';
import 'package:rent_2_go/favourites.dart';
import 'package:rent_2_go/new_rentals.dart';
import 'package:rent_2_go/screens/details/components/cartpage.dart';
import 'package:rent_2_go/screens/details/profile.dart';
import 'package:rent_2_go/screens/home/home_screen.dart';
import 'package:rent_2_go/screens/search/search_widget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(
      isAuthenticated: true,
    ),
    UserProductsPage(),
    AddProductPage(),
    FavoritesPage(),
    CartPage(),
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.black,
        color: Colors.yellow,
        buttonBackgroundColor: Colors.yellow,
        height: 60,
        animationDuration: Duration(milliseconds: 200),
        index: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const <Widget>[
          Icon(Icons.home, size: 30),
          Icon(CupertinoIcons.bag_fill, size: 30),
          Icon(Icons.add, size: 30),
          Icon(CupertinoIcons.heart_fill, size: 30),
          Icon(Icons.card_travel, size: 30),
          Icon(Icons.person_2, size: 30),
        ],
      ),
    );
  }
}
