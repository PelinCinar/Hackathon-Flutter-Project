import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meine/screens/favorites_book_provider.dart';
import 'package:provider/provider.dart';
import 'package:meine/core/LocalManager.dart';
import 'package:meine/screens/add_book_screen.dart';
import 'package:meine/screens/crud_screen.dart';
import 'package:meine/screens/login_screen.dart';
import 'package:meine/screens/profile_screen.dart';
import 'package:meine/screens/settings_screen.dart';
import 'package:meine/widget/bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  Set<String> favoriteBooks = {}; // Favori kitapları saklayan Set

  final List<Widget> _screens = [
    Center(child: Text('Ana Sayfa', style: TextStyle(fontSize: 24))),
    ProfileScreen(),
    SettingsScreen(),
    CrudScreen(),
  ];

  void _onItemTapped(int index) async {
    if (index == 1) {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
        if (result == true) {
          setState(() {
            _selectedIndex = index;
          });
        }
      } else {
        setState(() {
          _selectedIndex = index;
        });
      }
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localManager = Provider.of<LocalManager>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localManager.translate('title')),
        centerTitle: true,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _buildBookRow("assets/images/a.jpg", "Kitap Adı 1", "Yazar 1",
                    "assets/images/b.jpg", "Kitap Adı 2", "Yazar 2"),
                _buildBookRow("assets/images/c.jpg", "Kitap Adı 3", "Yazar 3",
                    "assets/images/d.jpg", "Kitap Adı 4", "Yazar 4"),
              ],
            ),
          ),
          ProfileScreen(),
          SettingsScreen(),
          CrudScreen(),
FavoriteBooksScreen()
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onTop: _onItemTapped,
      ),
    );
  }

  Widget _buildBookRow(String imagePath1, String bookName1, String authorName1,
      String imagePath2, String bookName2, String authorName2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildBookCard(imagePath1, bookName1, authorName1),
        _buildBookCard(imagePath2, bookName2, authorName2),
      ],
    );
  }

  Widget _buildBookCard(String imagePath, String bookName, String authorName) {
    double cardWidth = (MediaQuery.of(context).size.width - 48) / 2;

    return Container(
      width: cardWidth,
      margin: EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                  child: Image.asset(
                    imagePath,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bookName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        authorName,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: IconButton(
                icon: Icon(
                  favoriteBooks.contains(bookName)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: favoriteBooks.contains(bookName)
                      ? Colors.red
                      : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    if (favoriteBooks.contains(bookName)) {
                      favoriteBooks.remove(bookName);
                    } else {
                      favoriteBooks.add(bookName);
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
