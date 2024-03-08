import 'package:flutter/material.dart';

class AppFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // Your footer content here
      // For example, you can use a BottomNavigationBar:
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: BottomNavigationBar(
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(
                  context, '/home'); // Navigate to the HomeScreen
              break;
            case 1:
              Navigator.pushNamed(
                  context, '/contacts'); // Navigate to the ContactsScreen
              break;
            case 2:
              Navigator.pushNamed(
                  context, '/wallet'); // Navigate to the WalletScreen
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'Contacts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Wallet',
          ),
        ],
      ),
    );
  }
}
