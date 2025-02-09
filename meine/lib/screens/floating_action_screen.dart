import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FloatingActionScreen extends StatefulWidget {
  @override
  _FloatingActionScreenState createState() => _FloatingActionScreenState();
}

class _FloatingActionScreenState extends State<FloatingActionScreen> {
  Set<String> favoriteBooks = {}; // Favori kitapları tutacak Set

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Son Eklenen Kitaplar"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('books')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Henüz favori kitap eklenmedi.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var book = snapshot.data!.docs[index];
              return Card(
                margin: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Yuvarlatılmış köşeler
                ),
                elevation: 5, // Gölgeleme
                child: ListTile(
                  contentPadding: EdgeInsets.all(10),
                  leading: book['imageUrl'] != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      book['imageUrl'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  )
                      : Icon(Icons.book),
                  title: Text(
                    book['title'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text(
                    book['author'],
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      favoriteBooks.contains(book['title'])
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: favoriteBooks.contains(book['title'])
                          ? Colors.red
                          : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        if (favoriteBooks.contains(book['title'])) {
                          favoriteBooks.remove(book['title']);
                        } else {
                          favoriteBooks.add(book['title']);
                        }
                      });
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
