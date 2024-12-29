import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex; //which page is selected

  const BottomNavBar({
    required this.selectedIndex,
    super.key,
  });

//provides a bottom navigation bar with four pages
  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/rate');
        break;
      case 2:
        context.go('/users');
        break;
      case 3:
        context.go('/me');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.gas_meter_outlined), //hehe
          label: 'Rate',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group),
          label: 'Users',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Me',
        ),
      ],
      //when pressed, change color
      currentIndex: selectedIndex,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      onTap: (index) => _onItemTapped(context, index),
    );
  }
}
