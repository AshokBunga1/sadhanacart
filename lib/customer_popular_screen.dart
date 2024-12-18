



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PopularScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // List of different images for each index
    List<String> imagePaths = [
      'assets/images/wrogn_brand_image.jpeg', // Image 1
      'assets/images/allen_solly_image.png', // Image 2
      'assets/images/puma_image.png', // Image 3
      'assets/images/levis_image.png', // Image 4
      'assets/images/addidas.png', // Image 5
      'assets/images/nike_image.png', // Image 6
    ];

    // List of corresponding texts for each image
    List<String> labels = [
      'Wrogn', // Label for Image 1
      'Allen Solly', // Label for Image 2
      'Puma', // Label for Image 3
      'Levis', // Label for Image 4
      'Addidas', // Label for Image 5
      'Nike', // Label for Image 6
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
              'All Popular',
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

