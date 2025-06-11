import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import '../providers/cart_provider.dart'; // Adjust the path if needed

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    // Your screen widgets here
    Placeholder(), // Home
    Placeholder(), // Browse
    Placeholder(), // Cart (or leave empty if you push on tap)
    Placeholder(), // Profile
  ];

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 2) {
            Navigator.pushNamed(context, '/cart');
          } else {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Browse',
          ),

          /// ✅ Updated My Cart item with badge
          BottomNavigationBarItem(
            icon: badges.Badge(
              badgeContent: Text(
                '${cartProvider.cartItems.length}',
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
              showBadge: cartProvider.cartItems.isNotEmpty,
              child: const Icon(Icons.shopping_bag),
            ),
            label: 'My Cart',
          ),

          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
