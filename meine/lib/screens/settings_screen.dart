import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meine/core/ThemeManager.dart';
import 'package:meine/core/LocalManager.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final localManager = Provider.of<LocalManager>(context);

    final User? currentUser = FirebaseAuth.instance.currentUser; // Giriş yapan kullanıcıyı al

    return Scaffold(
      appBar: AppBar(
        title: Text(localManager.translate('settings')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kullanıcı Bilgisi
            Align(
              alignment: Alignment.topRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/profile.png'),
                  ),
                  SizedBox(height: 8),
                  Text(
                    currentUser?.displayName ?? 'Kullanıcı Adı', // Kullanıcı adı (Firebase'de varsa)
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    currentUser?.email ?? 'E-posta bulunamadı', // Kullanıcının e-postasını göster
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Tema Değiştirme
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localManager.translate('Temayı değiştiriniz'),
                  style: TextStyle(fontSize: 16),
                ),
                Switch(
                  value: themeManager.themeMode == ThemeMode.dark,
                  onChanged: (value) {
                    themeManager.toggleTheme();
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            // Dil Değiştirme
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localManager.translate('language'),
                  style: TextStyle(fontSize: 16),
                ),
                DropdownButton<Locale>(
                  value: localManager.currentLocale,
                  onChanged: (Locale? newLocale) {
                    if (newLocale != null) {
                      localManager.changedLocale(newLocale);
                    }
                  },
                  items: const [
                    DropdownMenuItem(
                      value: Locale('en'),
                      child: Text('English'),
                    ),
                    DropdownMenuItem(
                      value: Locale('tr'),
                      child: Text('Türkçe'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
