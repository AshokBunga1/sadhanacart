import 'package:flutter/material.dart';

import 'baby_care_screen.dart';
import 'customer_electronics_screen.dart';
import 'customer_fashion_screen.dart';
import 'customer_furniture_screen.dart';
import 'customer_popular_screen.dart';
import 'customer_vegetables_screen.dart';

class CategoriesTab extends StatefulWidget {
  @override
  _CategoriesTabState createState() => _CategoriesTabState();
}

class _CategoriesTabState extends State<CategoriesTab> {
  int _selectedIndex = 0;

  // List of screens corresponding to each category
  final List<Widget> _screens = [
    PopularScreen(),
    FashionScreen(),
    FurnitureScreen(),
    ElectronicsScreen(),
    VegetablesScreen(),
    BabyScreen(),
    CoolDrinksScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left Container with images
          Container(
            width: 80,
            color: Colors.grey.shade200,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Spacer at the top
                  const SizedBox(height: 50),
                  // "Popular" item
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 0; // Set index for Popular
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.star, // Popular icon
                            size: 50,
                            color: _selectedIndex == 0
                                ? Colors.blue
                                : Colors.black, // Highlight selected
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Popular',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: _selectedIndex == 0
                                  ? FontWeight.bold
                                  : FontWeight.normal, // Highlight selected label
                              color: _selectedIndex == 0
                                  ? Colors.blue
                                  : Colors.black, // Change color for selected
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Remaining items
                  ...List.generate(6, (index) {
                    // List of image paths and labels
                    List<String> imagePaths = [
                      'assets/fashion_circular_sadhana.jpg',
                      'assets/furniture_circular_sadhana.jpg',
                      'assets/electronics_circular_sadhana.jpg',
                      'assets/vegetables.jpg',
                      'assets/baby_circular_sadhana.png',
                      'assets/cool_drinks.jpg',
                    ];

                    List<String> labels = [
                      'Fashion',
                      'Furniture',
                      'Electronics',
                      'Vegetables',
                      'Baby care',
                      'Drinks',
                    ];

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = index + 1; // Update index for remaining items
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Column(
                          children: [
                            ClipOval(
                              child: Image.asset(
                                imagePaths[index],
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              labels[index],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: _selectedIndex == index + 1
                                    ? FontWeight.bold
                                    : FontWeight.normal, // Highlight selected label
                                color: _selectedIndex == index + 1
                                    ? Colors.blue
                                    : Colors.black, // Change color for selected label
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          // Right Container with selected screen
          Expanded(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              child: Container(
                key: ValueKey<int>(_selectedIndex), // Key for animation
                color: Colors.white,
                child: _screens[_selectedIndex], // Display selected screen
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CoolDrinksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Drinks Screen', style: TextStyle(fontSize: 24)));
  }
}
