
import 'package:flutter/material.dart';

import 'clothings_upload_screen.dart';
import 'furniture_upload_screen.dart';

class SellScreen extends StatefulWidget {
  @override
  _SellScreenState createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _controller.forward(); // Starts the animation
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller to free up resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // List of items with asset images, text labels, and their respective pages
    final List<Map<String, dynamic>> items = [
      {
        'image': 'assets/sell_clothings_main_image.jpeg',
        'label': 'Clothings',
        'page': UploadClothingItemsScreen(), // Define your page class
      },
      {
        'image': 'assets/sell_electronics_main_image.jpg',
        'label': 'Electronics',
        'page': ElectronicsPage(), // Define your page class
      },
      {
        'image': 'assets/sell_furniture_main_image.jpeg',
        'label': 'Furniture',
        'page': FurniturePage(), // Define your page class
      },
      {
        'image': 'assets/sell_footwear_main_image_1.jpeg',
        'label': 'Footwear',
        'page': FootwearPage(), // Define your page class
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 containers per row
            crossAxisSpacing: 10, // Horizontal spacing
            mainAxisSpacing: 10, // Vertical spacing
          ),
          itemCount: items.length, // Total 4 containers
          itemBuilder: (context, index) {
            final delay = index * 200; // Delay for staggered animation
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final opacity = Tween<double>(begin: 0, end: 1).animate(
                  CurvedAnimation(
                    parent: _controller,
                    curve: Interval(delay / 1000, 1, curve: Curves.easeInOut),
                  ),
                );
                final scale = Tween<double>(begin: 0.8, end: 1).animate(
                  CurvedAnimation(
                    parent: _controller,
                    curve: Interval(delay / 1000, 1, curve: Curves.easeOutBack),
                  ),
                );
                return Opacity(
                  opacity: opacity.value,
                  child: Transform.scale(
                    scale: scale.value,
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to the specific page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => items[index]['page']),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  items[index]['image'],
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                items[index]['label'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}




class ElectronicsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Manage your account here.', style: TextStyle(fontSize: 18)),
    );
  }
}

class FootwearPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Manage your account here.', style: TextStyle(fontSize: 18)),
    );
  }
}