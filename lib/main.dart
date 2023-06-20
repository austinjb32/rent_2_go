import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rent_2_go/screens/details/components/cartpage.dart';
import 'package:rent_2_go/screens/details/profile.dart';
import 'package:rent_2_go/screens/home/home_screen.dart';
import 'package:rent_2_go/screens/search/search_widget.dart';
import './main.dart';

import 'add_products.dart';
import 'constants.dart';
import 'login.dart';

class MyApp extends StatelessWidget {
  final bool isAuthenticated;

  const MyApp({Key? key, required this.isAuthenticated}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ren2Go',
      theme: ThemeData(
        scaffoldBackgroundColor: bgColor,
        primarySwatch: Colors.blue,
        fontFamily: "Gordita",
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        textTheme: const TextTheme(
          bodyText2: TextStyle(color: Colors.black54),
        ),
      ),
      home: LoginPage(),
    );
  }
}

Future<bool> performAuthenticationCheck() async {
  User? user = FirebaseAuth.instance.currentUser;
  return user != null;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Perform authentication check
  bool isAuthenticated = await performAuthenticationCheck();

  runApp(MyApp(isAuthenticated: isAuthenticated));
}

// class BottomNavigationWrapper extends StatefulWidget {
//   final Widget child;

//   const BottomNavigationWrapper({Key? key, required this.child})
//       : super(key: key);

//   @override
//   _BottomNavigationWrapperState createState() =>
//       _BottomNavigationWrapperState();
// }

// class _BottomNavigationWrapperState extends State<BottomNavigationWrapper> {
//   int _currentIndex = 0;

//   void _handleNavigation(int index) {
//     setState(() {
//       _currentIndex = index;
//     });

//     // Perform navigation based on the selected tab
//     switch (index) {
//       case 0:
//         Navigator.pushReplacementNamed(context, '/');
//         break;
//       case 1:
//         Navigator.pushReplacementNamed(context, '/search');
//         break;
//       case 2:
//         Navigator.pushReplacementNamed(context, '/add');
//         break;
//       case 3:
//         Navigator.pushReplacementNamed(context, '/cart');
//         break;
//       case 4:
//         Navigator.pushReplacementNamed(context, '/profile');
//         break;
//       // Add more cases for other tabs
//     }
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();

//     // Get the current route's name
//     final currentRoute = ModalRoute.of(context)?.settings.name;

//     // Update the current index based on the route
//     if (currentRoute == '/') {
//       _currentIndex = 0;
//     } else if (currentRoute == '/search') {
//       _currentIndex = 1;
//     } else if (currentRoute == '/add') {
//       _currentIndex = 2;
//     } else if (currentRoute == '/cart') {
//       _currentIndex = 3;
//     } else if (currentRoute == '/profile') {
//       _currentIndex = 3;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Check if the current route is the onboarding screen
//     final isOnboardingScreen =
//         ModalRoute.of(context)?.settings.name == '/login';

//     // Return the appropriate layout based on the current route
//     if (isOnboardingScreen) {
//       return Scaffold(body: widget.child);
//     } else {
//       return Scaffold(
//         body: widget.child,
//         bottomNavigationBar: BottomNavigationBar(
//           currentIndex: _currentIndex,
//           onTap: _handleNavigation,
//           selectedItemColor: Colors.blue,
//           unselectedItemColor: Colors.grey,
//           items: const [
//             BottomNavigationBarItem(
//               icon: Icon(Icons.home),
//               label: 'Home',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.search),
//               label: 'Search',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.add),
//               label: 'Add',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.shopping_cart),
//               label: 'Cart',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.person_2),
//               label: 'Profile',
//             ),
//           ],
//         ),
//       );
//     }
//   }
// }
