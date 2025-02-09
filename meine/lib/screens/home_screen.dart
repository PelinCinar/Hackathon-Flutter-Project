import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meine/screens/floating_action_screen.dart';
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
                Expanded(
                  child: ListView(
                    children: [
                      _buildBookRow("assets/images/a.jpg", "Kitap Adı 1", "Yazar 1",
                          "assets/images/b.jpg", "Kitap Adı 2", "Yazar 2"),
                      _buildBookRow("assets/images/c.jpg", "Kitap Adı 3", "Yazar 3",
                          "assets/images/d.jpg", "Kitap Adı 4", "Yazar 4"),
                      _buildBookRow("assets/images/e.jpg", "Kitap Adı 5", "Yazar 5",
                          "assets/images/f.jpg", "Kitap Adı 6", "Yazar 6"),
                      _buildFirebaseBooks(), // Firebase kitaplarını ekle
                    ],
                  ),
                ),
              ],
            ),
          ),
          ProfileScreen(),
          SettingsScreen(),
          CrudScreen(),
          FloatingActionScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onTop: _onItemTapped,
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddBookScreen()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue, // Buton rengi
      )
          : null, // Diğer sayfalarda görünmemesi için null
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

  Widget _buildBookCard(String imagePath, String bookName, String authorName, {bool isNetworkImage = false}) {
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
                  child: isNetworkImage
                      ? Image.network(
                    imagePath,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                      : Image.asset(
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

  Widget _buildFirebaseBooks() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('books').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Henüz kitap eklenmedi.'));
          }

          List<Widget> bookCards = [];
          for (var i = 0; i < snapshot.data!.docs.length; i += 2) {
            var book1 = snapshot.data!.docs[i];
            var book2 = (i + 1 < snapshot.data!.docs.length) ? snapshot.data!.docs[i + 1] : null;

            bookCards.add(
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildBookCard(book1['imageUrl'], book1['title'], book1['author'], isNetworkImage: true),
                  book2 != null
                      ? _buildBookCard(book2['imageUrl'], book2['title'], book2['author'], isNetworkImage: true)
                      : SizedBox(width: (MediaQuery.of(context).size.width - 48) / 2),
                ],
              ),
            );
          }

          return Column(children: bookCards);
         },
     );
  }
}