import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meine/screens/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final User? currentUser = _auth.currentUser;
    return Scaffold(
      appBar: AppBar(

        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Container(
            width: 300, // Genişlik
            height: 300, // Yükseklik
            decoration: BoxDecoration(
              color: Colors.white, // Arka plan rengi beyaz
              shape: BoxShape.circle, // Yuvarlak şekil
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5), // Gölge
                  blurRadius: 10, // Gölgenin bulanıklığı
                  offset: Offset(0, 4), // Gölgenin konumu
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.deepPurple, // Profil fotoğrafı için renk
                  child: Icon(
                    Icons.person, // Profil ikonu
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Hoşgeldin, ${currentUser?.email ?? 'Misafir'}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87, // Yazı rengi siyah
                    fontWeight: FontWeight.w600, // Yazı kalınlığı
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await _auth.signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                          (route) => false,
                    );
                  },
                  child: Text("Çıkış Yap"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
