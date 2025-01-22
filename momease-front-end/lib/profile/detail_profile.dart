import 'package:flutter/material.dart';
import 'package:front_end/profile/edit_profile.dart';

class DetailProfilePage extends StatefulWidget {
  @override
  _DetailProfilePageState createState() => _DetailProfilePageState();
}

class _DetailProfilePageState extends State<DetailProfilePage> {
  // Inisialisasi TextEditingController dengan data default
  final TextEditingController firstNameController =
      TextEditingController(text: 'Michie');
  final TextEditingController lastNameController =
      TextEditingController(text: 'Tanaka');
  final TextEditingController birthdateController =
      TextEditingController(text: '1990-01-01');
  final TextEditingController emailController =
      TextEditingController(text: 'michie@example.com');

  bool isEditMode = false; // Variabel untuk mengontrol mode edit

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isEditMode ? Icons.save : Icons.edit),
            onPressed: () {
              setState(() {
                isEditMode = !isEditMode; // Toggle mode edit
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Memusatkan elemen
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Gambar profil
            CircleAvatar(
              radius: 50.0,
              backgroundImage: AssetImage(
                  'assets/image_profile/michie.png'), // Path gambar Anda
            ),
            SizedBox(height: 20.0),

            // Kolom first name
            TextField(
              controller: firstNameController,
              readOnly: !isEditMode, // Hanya dapat diubah pada mode edit
              decoration: InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12.0),

            // Kolom last name
            TextField(
              controller: lastNameController,
              readOnly: !isEditMode,
              decoration: InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12.0),

            // Kolom birthdate
            TextField(
              controller: birthdateController,
              readOnly: !isEditMode,
              decoration: InputDecoration(
                labelText: 'Birthdate',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12.0),

            // Kolom email
            TextField(
              controller: emailController,
              readOnly: !isEditMode,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),

            // Tombol untuk halaman Edit Profile
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfilePage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
                backgroundColor: Color(0xff97CBFB),
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
