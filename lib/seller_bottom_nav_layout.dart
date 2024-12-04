import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sadhanacart/select_sell_type.dart';



class BottomNavBarScreen extends StatefulWidget {
  @override
  _BottomNavBarScreenState createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    ChatScreen(),
    SellScreen(),
    MyProductsScreen(),
    AccountScreen(),
  ];

  final List<String> _appBarTitles = [
    'Home',
    'Chat',
    'Sell Something',
    'My Ads',
    'Account',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _appBarTitles[_currentIndex],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
          return FadeThroughTransition(
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          BottomNavigationBar(
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.blueAccent,
            unselectedItemColor: Colors.grey,
            onTap: (index) {
              if (index == 2) return; // Skip handling for the 'Sell' button here
              setState(() {
                _currentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: SizedBox.shrink(), // Empty space for Sell button
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: 'My Products',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Account',
              ),
            ],
          ),
          Positioned(
            bottom: 10, // Adjust the height of the button
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex = 2;
                });
              },
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueAccent,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 35,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Welcome to Home Screen', style: TextStyle(fontSize: 18)),
    );
  }
}

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Chat with others here!', style: TextStyle(fontSize: 18)),
    );
  }
}



class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Manage your account here.', style: TextStyle(fontSize: 18)),
    );
  }
}


class MyProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Manage your account here.', style: TextStyle(fontSize: 18)),
    );
  }
}