import 'package:flutter/material.dart';

import 'package:gemini_chat_bot/askAi/presentation/ask_ai_screen.dart';
import 'package:gemini_chat_bot/contact_us/presentation/contact_us_screen.dart';
import 'package:gemini_chat_bot/favourites/presentation/favourites_screen.dart';
import 'package:gemini_chat_bot/home/presentation/home_screen.dart';
import 'package:gemini_chat_bot/featuers/chat/presentation/views/chat_view.dart';
import 'package:gemini_chat_bot/video.dart';
class NavigationBarSection extends StatefulWidget {
  const NavigationBarSection({super.key});

  @override
  _NavigationBarSectionState createState() => _NavigationBarSectionState();
}

class _NavigationBarSectionState extends State<NavigationBarSection> {
  int _currentIndex = 0;
 

  // List of pages for navigation
  final List<Widget> _pages = [
    HomeScreen(),
    ContactUsPage(),
    FavoritesPage(favorites: favorites),
    ChatView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      body: _pages[_currentIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/homeIcon.png', width: 25, height: 25),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/messageIcon.png', width: 25, height: 25),
            label: 'Contact Us',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/favIcon.png', width: 22, height: 22),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/botIcon.png', width: 25, height: 25),
            label: 'Ask AI',
          ),
        ],
      ),
    );
  }
}
