// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
//
// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({super.key});
//
//   @override
//   State<OnboardingScreen> createState() => _OnboardingScreenState();
// }
//
// class _OnboardingScreenState extends State<OnboardingScreen> {
//   final PageController _controller = PageController();
//   int _currentPage = 0;
//
//   final List<Map<String, String>> _pages = [
//     {
//       'title': 'Discover Products',
//       'subtitle': 'Find the best products from top brands.',
//       'image': 'assets/onbording_1.1.gif',
//     },
//     {
//       'title': 'Easy Checkout',
//       'subtitle': 'Fast and secure payment options.',
//       'image': 'assets/onbording_1.2.gif',
//     },
//     {
//       'title': 'Track Your Orders',
//       'subtitle': 'Real-time order tracking at your fingertips.',
//       'image': 'assets/onbording_1.3.gif',
//     },
//   ];
//
//   void _onNextPressed() {
//     if (_currentPage < _pages.length - 1) {
//       _controller.nextPage(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     } else {
//       // Navigate to home screen or login screen
//     }
//   }
//
//   void _onSkipPressed() {
//     _controller.jumpToPage(_pages.length - 1);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           PageView.builder(
//             controller: _controller,
//             onPageChanged: (index) {
//               setState(() {
//                 _currentPage = index;
//               });
//             },
//             itemCount: _pages.length,
//             itemBuilder: (context, index) {
//               final page = _pages[index];
//               return Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Animate(
//                     effects: const [
//                       FadeEffect(duration: Duration(milliseconds: 800)),
//                       ScaleEffect(duration: Duration(milliseconds: 600)),
//                     ],
//                     child: Image.asset(
//                       page['image']!,
//                       height: 300,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Text(
//                     page['title']!,
//                     style: const TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ).animate(
//                     effects: const [
//                       SlideEffect(
//                         curve: Curves.easeInOut,
//                         begin: Offset(-0.5, 0),
//                         end: Offset.zero,
//                         duration: Duration(milliseconds: 500),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     page['subtitle']!,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       color: Colors.black54,
//                     ),
//                     textAlign: TextAlign.center,
//                   ).animate(
//                     effects: const [
//                       SlideEffect(
//                         curve: Curves.easeInOut,
//                         begin: Offset(0.5, 0),
//                         end: Offset.zero,
//                         duration: Duration(milliseconds: 500),
//                       ),
//                     ],
//                   ),
//                 ],
//               );
//             },
//           ),
//           Positioned(
//             bottom: 60,
//             left: 20,
//             right: 20,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 TextButton(
//                   onPressed: _onSkipPressed,
//                   child: const Text(
//                     "Skip",
//                     style: TextStyle(color: Colors.blue, fontSize: 16),
//                   ),
//                 ),
//                 Row(
//                   children: List.generate(
//                     _pages.length,
//                         (index) => Container(
//                       margin: const EdgeInsets.only(right: 8),
//                       width: _currentPage == index ? 12 : 8,
//                       height: _currentPage == index ? 12 : 8,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: _currentPage == index
//                             ? Colors.blue
//                             : Colors.grey.shade400,
//                       ),
//                     ),
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: _onNextPressed,
//                   child: Text(
//                     _currentPage == _pages.length - 1 ? "Done" : "Next",
//                     style: const TextStyle(color: Colors.blue, fontSize: 16),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'Customer_home_screen.dart';
import 'customer_signin.dart';
import 'customer_welcome_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  late Timer _timer;

  final List<Map<String, String>> _pages = [
    {
      'title': 'Discover Products',
      'subtitle': 'Find the best products from top brands.',
      'image': 'assets/images/ecomerce_onbording_1.1.png',
    },
    {
      'title': 'Easy Checkout',
      'subtitle': 'Fast and secure payment options.',
      'image': 'assets/images/ecomerce_onbording_1.2.png',
    },
    {
      'title': 'Track Your Orders',
      'subtitle': 'Real-time order tracking at your fingertips.',
      'image': 'assets/images/ecomerce_onbording_1.3.png',
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < _pages.length - 1) {
        _controller.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        _navigateToWelcomeScreen();
        timer.cancel();
      }
    });
  }

  void _navigateToWelcomeScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CustomerSigninScreen()),
    );
  }

  void _onNextPressed() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToWelcomeScreen();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              final page = _pages[index];
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Animate(
                    effects: const [
                      FadeEffect(duration: Duration(milliseconds: 800)),
                      ScaleEffect(duration: Duration(milliseconds: 600)),
                    ],
                    child: Image.asset(
                      page['image']!,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    page['title']!,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ).animate(
                    effects: const [
                      SlideEffect(
                        curve: Curves.easeInOut,
                        begin: Offset(-0.5, 0),
                        end: Offset.zero,
                        duration: Duration(milliseconds: 500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    page['subtitle']!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ).animate(
                    effects: const [
                      SlideEffect(
                        curve: Curves.easeInOut,
                        begin: Offset(0.5, 0),
                        end: Offset.zero,
                        duration: Duration(milliseconds: 500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                          (index) => Container(
                        margin: const EdgeInsets.only(right: 8),
                        width: _currentPage == index ? 12 : 8,
                        height: _currentPage == index ? 12 : 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? Colors.indigo
                              : Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            top: 40,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.indigo.shade100, // Background color set to indigo shade 100
                borderRadius: BorderRadius.circular(8), // Optional: Add rounded corners
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), // Optional: Add padding for better touch area
              child: TextButton(
                onPressed: _navigateToWelcomeScreen,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero, // Remove default padding from TextButton
                  minimumSize: Size.zero, // Set minimum size to zero for custom padding to take effect
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Shrink button tap target to content
                ),
                child: const Text(
                  "Skip",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            left: 20,
            right: 20,
            child: Container(
              width: 325,
              height: 48, // Optional: Set height for consistent button sizing
              decoration: BoxDecoration(
                color: Colors.indigo, // Set the background color to indigo
                borderRadius: BorderRadius.circular(8), // Optional: Add rounded corners
              ),
              child: TextButton(
                onPressed: _onNextPressed,
                child: Text(
                  _currentPage == _pages.length - 1 ? "Done" : "Next",
                  style: const TextStyle(color: Colors.white, fontSize: 16), // Text color to white for contrast
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


