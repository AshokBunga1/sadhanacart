import 'package:bus_booking_app/sadhanaCart/seller/sadhana_seller_home_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SellerSignInScreen extends StatefulWidget {
  @override
  _SellerSignInScreenState createState() => _SellerSignInScreenState();
}

class _SellerSignInScreenState extends State<SellerSignInScreen> {
  late bool isSigning = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      // If user is already logged in, navigate to the home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => BottomNavBarScreen()),
      );
    }
  }

  Future<void> _signInWithGoogle() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      setState(() => isSigning = true);

      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        UserCredential userCredential = await auth.signInWithCredential(credential);
        User? user = userCredential.user;

        if (user != null) {
          final userRef = FirebaseFirestore.instance.collection('seller').doc(user.uid);

          final docSnapshot = await userRef.get();
          if (!docSnapshot.exists) {
            await userRef.set({
              'email': user.email,
              'name': user.displayName,
              'createdAt': FieldValue.serverTimestamp(),
              'status': 'loggedIn', // Store loggedIn status
            });
          } else {
            await userRef.update({'status': 'loggedIn'}); // Update status to loggedIn if user exists
          }

          // Save login status locally
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);

          setState(() => isSigning = false);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => BottomNavBarScreen()),
          );
        }
      }
    } catch (e) {
      setState(() => isSigning = false);
      Fluttertoast.showToast(msg: "Error $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 55,
              width: 325,
              child: ElevatedButton(
                onPressed: _signInWithGoogle,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Image.asset(
                          'assets/google_logo_officiall.png',
                          width: 24,
                          height: 24,
                        ),
                      ),
                      TextSpan(
                        text: 'oogle',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}