import 'dart:io';

import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final int pageIndex;
  final Function(int) onTap;

  const NavBar({
    super.key,
    required this.pageIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: Platform.isAndroid ? 16 : 0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(pageIndex == 0 ? Icons.home : Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(pageIndex == 1 ? Icons.explore : Icons.explore_outlined),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(pageIndex == 2 ? Icons.favorite : Icons.favorite_outline),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(pageIndex == 3 ? Icons.receipt_long : Icons.receipt_long_outlined),
            label: 'Tickets',
          ),
          BottomNavigationBarItem(
            icon: Icon(pageIndex == 4 ? Icons.person : Icons.person_outline),
            label: 'Profile',
          ),
        ],
        currentIndex: pageIndex,
        selectedItemColor: Colors.deepPurpleAccent,
        unselectedItemColor: Colors.grey,
        onTap: onTap,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontSize: 12),
      ),
    );
  }
}
