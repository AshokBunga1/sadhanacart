import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FashionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // List of different images for each index
    List<String> imagePaths = [
      'assets/images/men_fashion_sadhana.png', // Image 1
      'assets/images/women_fashion_sadhana.jpeg', // Image 2
      'assets/images/kids_fashion_sadhana.jpeg', // Image 3
      'assets/images/jewellery_sadhana.jpeg', // Image 4
      'assets/images/casmotics_sadhana.jpeg', // Image 5
    ];

    // List of corresponding texts for each image
    List<String> labels = [
      'Men', // Label for Image 1
      'Women', // Label for Image 2
      'Kids', // Label for Image 3
      'Jewellery', // Label for Image 4
      'Casmotics', // Label for Image 5
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade100, // Set background color for the screen
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding for better spacing
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align items from the top
          children: [
            // Header Text
            Text(
              'All Fashion',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20), // Space between header and items

            // Grid view for fixed rows and columns
            GridView.builder(
              shrinkWrap: true, // Prevent grid from taking up extra space
              physics: NeverScrollableScrollPhysics(), // Disable scrolling for this grid
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 items per row
                crossAxisSpacing: 16.0, // Space between items horizontally
                mainAxisSpacing: 16.0, // Space between items vertically
                childAspectRatio: 0.75, // Aspect ratio for the images
              ),
              itemCount: imagePaths.length, // Total number of items in the grid
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        imagePaths[index], // Get respective image
                        height: 60, // Image height
                        width: 60,  // Image width
                        fit: BoxFit.cover, // Fit image within the container
                      ),
                    ),
                    const SizedBox(height: 8), // Space between image and text
                    Text(
                      labels[index], // Get respective label
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

