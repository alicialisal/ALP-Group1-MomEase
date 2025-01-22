import 'package:flutter/material.dart';
import 'package:front_end/profile/edit_profile.dart';

class DetailProfilePage extends StatelessWidget {
  // Inisialisasi TextEditingController dengan data default
  final TextEditingController firstNameController =
      TextEditingController(text: 'Michie');
  final TextEditingController lastNameController =
      TextEditingController(text: 'Tanaka');
  final TextEditingController passwordController =
      TextEditingController(text: 'password123');
  final TextEditingController birthdateController =
      TextEditingController(text: '1990-01-01');
  final TextEditingController emailController =
      TextEditingController(text: 'michie@example.com');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Memusatkan semua elemen
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Gambar profil
            CircleAvatar(
              radius: 50.0,
              backgroundImage: AssetImage(
                  'assets/image_profile/michie.png'), // Ganti dengan path gambar Anda
            ),
            SizedBox(height: 20.0),

            // Kolom first name dengan data yang sudah terisi
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12.0),

            // Kolom last name dengan data yang sudah terisi
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12.0),

            // Kolom password dengan data yang sudah terisi
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12.0),

            // Kolom birthdate dengan data yang sudah terisi
            TextField(
              controller: birthdateController,
              decoration: InputDecoration(
                labelText: 'Birthdate',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12.0),

            // Kolom email dengan data yang sudah terisi
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),

            // Tombol Edit Profile
            ElevatedButton(
              onPressed: () {
                // Arahkan ke halaman Edit Profile
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfilePage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
                backgroundColor:
                    Color(0xff97CBFB), // Warna latar belakang tombol
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text('Edit Profile', style: TextStyle(fontSize: 16.0)),
            ),
          ],
        ),
      ),
    );
  }
}
