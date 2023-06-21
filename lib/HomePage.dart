import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.yellow,
        unselectedItemColor: Colors.black,
        backgroundColor: Colors.black,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.bag_fill),
            label: 'Your Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.heart_fill),
            label: 'Favourites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_travel),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
