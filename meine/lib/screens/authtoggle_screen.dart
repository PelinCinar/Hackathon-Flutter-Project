// auth_toggle_screen.dart
import 'package:flutter/material.dart';
import 'package:meine/screens/login_screen.dart';
import 'package:meine/screens/register_screen.dart';

class AuthToggleScreen extends StatefulWidget {
  @override
  _AuthToggleScreenState createState() => _AuthToggleScreenState();
}

class _AuthToggleScreenState extends State<AuthToggleScreen> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Authentication")),
      body: PageView(
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        children: [
          LoginScreen(),
          RegisterScreen(),
        ],
        onPageChanged: (index) {
          setState(() {});
        },
      ),
      bottomSheet: Container(
        color: Colors.white,
        height: 60,
        child: Center(
          child: GestureDetector(
            onTap: () {
              if (_pageController.page == 0) {
                _pageController.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
              } else {
                _pageController.animateToPage(0, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
              }
            },
            child: Text(
              _pageController.page == 0
                  ? "Don't have an account? Register"
                  : "Already have an account? Login",
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
