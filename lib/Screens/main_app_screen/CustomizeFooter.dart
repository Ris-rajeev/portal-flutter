import 'package:flutter/material.dart';

class CustomizedFooter extends StatelessWidget {
  final IconData homeIcon;
  final IconData squareIcon;
  final IconData addIcon;
  final List<String> labels;
  final List<Function()> onTapActions;

  CustomizedFooter({
    required this.homeIcon,
    required this.squareIcon,
    required this.addIcon,
    required this.labels,
    required this.onTapActions,
  });

  @override
  Widget build(BuildContext context) {
    assert(labels.length == 3 && onTapActions.length == 3);

    return Container(
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
        onTap: (index) {
          onTapActions[index]();
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(homeIcon),
            label: labels[0],
          ),
          BottomNavigationBarItem(
            icon: Icon(squareIcon),
            label: labels[1],
          ),
          BottomNavigationBarItem(
            icon: Icon(addIcon),
            label: labels[2],
          ),
        ],
      ),
    );
  }
}
