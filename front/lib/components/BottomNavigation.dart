import 'package:flutter/material.dart';
import '../utils/constants.dart';

class BottomNavigation extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigation({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: white,
      currentIndex: widget.currentIndex,
      onTap: widget.onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.person, color: primaryColor),
          label: 'Perfil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book, color: primaryColor),
          label: 'Receitas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment, color: primaryColor),
          label: 'Missões',
        ),
      ],
    );
  }
}

