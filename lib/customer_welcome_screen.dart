// import 'package:flutter/material.dart';
// import 'package:sadhanacart/customer_signin.dart';
//
// import 'Customer_home_screen.dart';
// import 'customer_sign_up.dart';
//
// class WelcomeScreen extends StatefulWidget {
//   const WelcomeScreen({Key? key}) : super(key: key);
//
//   @override
//   State<WelcomeScreen> createState() => _WelcomeScreenState();
// }
//
// class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _logoAnimation;
//   late Animation<double> _textAnimation;
//   late Animation<double> _buttonAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Animation Controller for all animations
//     _animationController = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     );
//
//     // Logo Animation - Fade In & Scale Up
//     _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//
//     // Text Animation - Fade In
//     _textAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//
//     // Button Animation - Fade In with Delay
//     _buttonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Interval(0.5, 1.0, curve: Curves.easeInOut)),
//     );
//
//     // Start the animation
//     _animationController.forward();
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.indigo.shade100,
//       body: Center(
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Logo Animation
//               FadeTransition(
//                 opacity: _logoAnimation,
//                 child: ScaleTransition(
//                   scale: _logoAnimation,
//                   child: const Icon(
//                     Icons.shopping_cart_outlined,
//                     size: 80,
//                     color: Colors.indigo,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 40),
//
//               // Welcome Text Animation
//               FadeTransition(
//                 opacity: _textAnimation,
//                 child: const Text(
//                   'Welcome to Sadhana!',
//                   style: TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.indigo,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 11,),
//               Align(
//                 alignment: Alignment.center,
//                   child: Text("From your wishlist to your doorstep, we bring quality and convenience to every order!",
//                   textAlign: TextAlign.center,
//                     style: TextStyle(color: Colors.white,fontSize: 20),
//                   ),
//               ),
//                SizedBox(height: 45),
//
//               // Optionally, add a button to navigate to Signin
//               FadeTransition(
//                 opacity: _buttonAnimation,
//                 child: GestureDetector(
//                   onTap: () {
//                     // Navigate to Signup screen
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => SignInScreen()),
//                     );
//                   },
//                   child: Container(
//                     width: 325,
//                     padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 40.0),
//                     decoration: BoxDecoration(
//                       color: Colors.transparent,
//                       borderRadius: BorderRadius.circular(8.0),
//                       border: Border.all(color: Colors.indigo, width: 2),
//                     ),
//                     child: Align(
//                       child: Text(
//                         'Sign In',
//                         style: TextStyle(
//                           color: Colors.indigo,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//
//               // Optionally, add a button to navigate to Signup
//               FadeTransition(
//                 opacity: _buttonAnimation,
//                 child: GestureDetector(
//                   onTap: () {
//                     // Navigate to Signup screen
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => SignupScreen()),
//                     );
//                   },
//                   child: Container(
//                     width: 325,
//                     padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 40.0),
//                     decoration: BoxDecoration(
//                       color: Colors.transparent,
//                       borderRadius: BorderRadius.circular(8.0),
//                       border: Border.all(color: Colors.indigo, width: 2),
//                     ),
//                     child: Align(
//                       alignment: Alignment.center,
//                       child: Text(
//                         'Sign Up',
//                         style: TextStyle(
//                           color: Colors.indigo,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               // Skip Button with Animation
//               FadeTransition(
//                 opacity: _buttonAnimation,
//                 child: GestureDetector(
//                   onTap: () {
//                     // Navigate to Signin screen (You can navigate to Signup screen similarly)
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => HomeScreen()),
//                     );
//                   },
//                   child: Container(
//                     width: 325,
//                     padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 40.0),
//                     margin: EdgeInsets.only(top: 40),
//                     decoration: BoxDecoration(
//                       color: Colors.indigo,
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                     child: Align(
//                       alignment: Alignment.center,
//                       child: Text(
//                         'Skip',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
//
//

// import 'package:flutter/material.dart';
//
// class WelcomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Center(
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Logo
//               Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.indigo),
//               SizedBox(height: 40),
//               // Welcome Text with Bold Font
//               Text('Welcome to Sadhana!',
//                   style: TextStyle(
//                     fontSize: 30,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   )),
//               SizedBox(height: 20),
//               // Tagline
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                 child: Text(
//                   "From your wishlist to your doorstep, we bring quality and convenience to every order!",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(color: Colors.white70, fontSize: 20),
//                 ),
//               ),
//               SizedBox(height: 45),
//               // Sign In Button with Bold Text
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.indigo,
//                   padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 40.0),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                 ),
//                 onPressed: () {},
//                 child: Text(
//                   'Sign In',
//                   style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               SizedBox(height: 16),
//               // Sign Up Button
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: Colors.indigo, backgroundColor: Colors.transparent,
//                   padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 40.0),
//                   side: BorderSide(color: Colors.indigo, width: 2),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                 ),
//                 onPressed: () {},
//                 child: Text(
//                   'Sign Up',
//                   style: TextStyle(color: Colors.indigo, fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo.shade500, Colors.indigo.shade900],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Welcome Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Logo
                Animate(
                  effects: [
                    FadeEffect(duration: Duration(milliseconds: 1000)),
                    ScaleEffect(duration: Duration(milliseconds: 800)),
                  ],
                  child: Image.asset(
                    'assets/images/logo.png', // Add your logo here
                    height: 120,
                  ),
                ),

                const SizedBox(height: 20),

                // Title with Slide Animation
                Text(
                  "Welcome to ShopEasy",
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ).animate(
                  effects: [
                    SlideEffect(
                      curve: Curves.easeInOut,
                      begin: Offset(0, 0.5),
                      end: Offset.zero,
                      duration: Duration(milliseconds: 800),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Subtitle with Fade Animation
                Text(
                  "Your one-stop shop for everything",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ).animate(
                  effects: [
                    FadeEffect(
                      duration: Duration(milliseconds: 800),
                      curve: Curves.easeIn,
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // E-commerce Illustration
                Image.asset(
                  'assets/images/ecommerce_illustration.png', // Replace with an illustration or image
                  height: 250,
                ).animate(
                  effects: [
                    SlideEffect(
                      curve: Curves.easeInOut,
                      begin: Offset(0, 0.5), // Correct Offset for start position
                      end: Offset.zero, // Correct Offset for end position
                      duration: Duration(milliseconds: 800),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Get Started Button
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the next screen
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.indigo, backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    elevation: 5,
                  ),
                  child: const Text(
                    "Get Started",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ).animate(
                  effects: [
                    SlideEffect(
                      curve: Curves.easeInOut,
                      begin: Offset(0, 0.5), // Correct Offset for start position
                      end: Offset.zero, // Correct Offset for end position
                      duration: Duration(milliseconds: 800),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
