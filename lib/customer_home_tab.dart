import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatefulWidget {
  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int _currentIndex = 0; // Current index for the carousel
  final CarouselController _controller = CarouselController(); // Controller for the carousel
  double borderRadius = 12.0; // Set a single border radius for all images
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      child: Container(
        child: Center(
          key: ValueKey<int>(1),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Light grey background
                      borderRadius: BorderRadius.circular(8), // Rounded edges
                      border: Border.all(color: Colors.black12)
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search here...',
                        hintStyle: TextStyle(color: Colors.grey[600]), // Hint color
                        border: InputBorder.none,
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey, // Search icon color
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 12), // Adjust padding
                      ),
                      onChanged: (value) {
                        // Handle search logic here
                        print("Search query: $value");
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10), // Additional spacing if needed
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 20, // Text size
                        fontWeight: FontWeight.bold, // Text weight
                        color: Colors.black, // Text color
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10), // Space between the title and the image row
                // Row with circular images that scrolls
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(6, (index) {
                      // List of different images for each index
                      List<String> imagePaths = [
                        'assets/images/fashion_circular_sadhana.jpg', // Image 1
                        'assets/images/furniture_circular_sadhana.jpg', // Image 2
                        'assets/images/electronics_circular_sadhana.jpg', // Image 3
                        'assets/images/vegetables.jpg', // Image 4
                        'assets/images/baby_circular_sadhana.png', // Image 5
                        'assets/images/cool_drinks.jpg', // Image 6
                      ];

                      // List of corresponding texts for each image
                      List<String> labels = [
                        'Fashion', // Label for Image 1
                        'Furniture', // Label for Image 2
                        'Electronics', // Label for Image 3
                        'Vegetables', // Label for Image 4
                        'Baby care', // Label for Image 5
                        'Drinks', // Label for Image 6
                      ];

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            ClipOval(
                              child: Image.asset(
                                imagePaths[index], // Get the respective image based on the index
                                height: 80, // Image height
                                width: 80,  // Image width
                                fit: BoxFit.cover, // Crop or scale the image to fit the circle
                              ),
                            ),
                            const SizedBox(height: 5), // Space between image and text
                            Text(
                              labels[index], // Get the respective label based on the index
                              style: TextStyle(
                                fontSize: 14, // Text size
                                fontWeight: FontWeight.w500, // Optional: Adjust font weight
                                color: Colors.black, // Text color
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Exclusive offers',
                      style: TextStyle(
                        fontSize: 20, // Text size
                        fontWeight: FontWeight.bold, // Text weight
                        color: Colors.black, // Text color
                      ),
                    ),
                  ),
                ),
                  CarouselSlider(
                  items: [
                    // Image.asset(
                    //   'assets/fashion_offer_sadhana.png', // Replace with your own images
                    //   fit: BoxFit.cover,
                    // ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(borderRadius),
                      child: Image.asset(
                        'assets/images/kids_fashion_offer_sadhana.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Image.asset(
                    //   'assets/furniture_offer_sadhana.png',
                    //   fit: BoxFit.cover,
                    // ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(borderRadius),
                      child: Image.asset(
                        'assets/images/mobiles_offers_sadhana.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Image.asset(
                    //   'assets/image5.jpg',
                    //   fit: BoxFit.cover,
                    // ),
                  ],
                  options: CarouselOptions(
                    height: 200, // Height of carousel
                    enlargeCenterPage: true, // Make the center item larger
                    autoPlay: true, // Auto play carousel
                    autoPlayInterval: Duration(seconds: 3), // Auto play interval
                    autoPlayAnimationDuration: Duration(milliseconds: 800), // Animation duration for auto play
                    enableInfiniteScroll: true, // Allow infinite scrolling
                    pageSnapping: true, // Ensure snapping behavior
                    scrollPhysics: BouncingScrollPhysics(), // Bouncy scroll effect
                    viewportFraction: 0.9, // Fraction of width visible per item
                    enlargeFactor: 0.3, // Amount to enlarge the center image
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                ),
                SizedBox(height: 10),
                // Dots Indicator Below the Carousel
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5, // Number of images
                        (index) => AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        color: _currentIndex == index ? Colors.blue : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Brands',
                      style: TextStyle(
                        fontSize: 20, // Text size
                        fontWeight: FontWeight.bold, // Text weight
                        color: Colors.black, // Text color
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(6, (index) {
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

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                imagePaths[index], // Get the respective image based on the index
                                height: 80, // Image height
                                width: 80,  // Image width
                                fit: BoxFit.cover, // Crop or scale the image to fit the circle
                              ),
                            ),
                            const SizedBox(height: 5), // Space between image and text
                            Text(
                              labels[index], // Get the respective label based on the index
                              style: TextStyle(
                                fontSize: 14, // Text size
                                fontWeight: FontWeight.w500, // Optional: Adjust font weight
                                color: Colors.black, // Text color
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 10), // Space between header and divider

                // Divider
                Divider(
                  color: Colors.grey, // Set the color of the divider
                  thickness: 1.0, // Set the thickness of the divider
                ),
                const SizedBox(height: 10), // Space between divider and grid
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'For you',
                      style: TextStyle(
                        fontSize: 20, // Text size
                        fontWeight: FontWeight.bold, // Text weight
                        color: Colors.black, // Text color
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Cloths bassed on your search',
                      style: TextStyle(
                        fontSize: 15, // Text size
                        color: Colors.grey, // Text color
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // First Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildCustomContainer(
                            imagePath: 'assets/images/wrogn_shirt_sadhana_1.jpeg',
                            title: 'Wrogn',
                            subText1: 'Subtext 1',
                            subText2: 'Subtext 2',
                            iconText: '4.5',
                          ),
                          _buildCustomContainer(
                            imagePath: 'assets/images/wrogn_tshirt_sadhana_2.jpeg',
                            title: 'Allen Solly',
                            subText1: 'Subtext 1',
                            subText2: 'Subtext 2',
                            iconText: '4.7',
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0), // Space between rows

                      // Second Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildCustomContainer(
                            imagePath: 'assets/images/wrogn_shirt_sadhana_3.jpeg',
                            title: 'Puma',
                            subText1: 'Subtext 1',
                            subText2: 'Subtext 2',
                            iconText: '4.8',
                          ),
                          _buildCustomContainer(
                            imagePath: 'assets/images/wrogn_white_shirt_sadhana_4.jpeg',
                            title: 'Levis',
                            subText1: 'Subtext 1',
                            subText2: 'Subtext 2',
                            iconText: '4.6',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey, // Set the color of the divider
                  thickness: 1.0, // Set the thickness of the divider
                ),
                const SizedBox(height: 10), // Space between divider and grid
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'For you',
                      style: TextStyle(
                        fontSize: 20, // Text size
                        fontWeight: FontWeight.bold, // Text weight
                        color: Colors.black, // Text color
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Mobile phones bassed on your search',
                      style: TextStyle(
                        fontSize: 15, // Text size
                        color: Colors.grey, // Text color
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // First Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildCustomContainer(
                            imagePath: 'assets/images/mobile_image_sadhana.jpeg',
                            title: 'iPhone',
                            subText1: 'Subtext 1',
                            subText2: 'Subtext 2',
                            iconText: '4.5',
                          ),
                          _buildCustomContainer(
                            imagePath: 'assets/images/mobile_image_sadhana_2.png',
                            title: 'vivo',
                            subText1: 'Subtext 1',
                            subText2: 'Subtext 2',
                            iconText: '4.7',
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0), // Space between rows

                      // Second Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildCustomContainer(
                            imagePath: 'assets/images/mobile_image_sadhana_2.png',
                            title: 'vivo',
                            subText1: 'Subtext 1',
                            subText2: 'Subtext 2',
                            iconText: '4.8',
                          ),
                          _buildCustomContainer(
                            imagePath: 'assets/images/mobile_image_sadhana_4.jpeg',
                            title: 'vivo',
                            subText1: 'Subtext 1',
                            subText2: 'Subtext 2',
                            iconText: '4.6',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildCustomContainer({
    required String imagePath,
    required String title,
    required String subText1,
    required String subText2,
    required String iconText,
  }) {
    return Container(
      width: 200, // Adjust width as needed
      height: 200, // Adjust height as needed
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Image covering 70% of the container
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 140, // 70% of height
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
              child: Image.asset(
                imagePath, // Pass respective image
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Content in the bottom 30%
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 60, // 30% of height
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title, // Pass title text
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        subText1, // Pass subtext 1
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        subText2, // Pass subtext 2
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Top-right icon in a rounded container
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite, // Example icon
                color: Colors.white,
                size: 14,
              ),
            ),
          ),

          // Bottom-right small container with icon and text
          Positioned(
            top: 115,
            right: 8,
            child: Container(
              height: 20,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star, // Example icon
                    color: Colors.white,
                    size: 12,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    iconText, // Pass icon text
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}





