import 'package:flutter/material.dart';

class ExploreTab extends StatefulWidget {
  @override
  _ExploreTabState createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  String selectedTab = "All Products"; // Default tab to show "All Products"

  // Method to update the tab
  void updateTab(String newTab) {
    setState(() {
      selectedTab = newTab; // Change the selected tab
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Display content based on the selected tab
          Expanded(
            child: selectedTab == "All Products"
                ? Center(
              child: Text(
                "Here are all the products.",
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
                : Center(
              child: Text(
                "Here are all the sellers.",
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

