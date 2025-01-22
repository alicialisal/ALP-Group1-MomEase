import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
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

  // Variabel untuk menyimpan gambar
  File? _image;

  // Fungsi untuk memilih gambar dari galeri atau kamera
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        source: ImageSource
            .gallery); // Atau gunakan ImageSource.camera untuk kamera
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Gambar profil
                GestureDetector(
                  onTap: _pickImage, // Memilih gambar saat gambar ditekan
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundImage: _image != null
                        ? FileImage(_image!)
                        : AssetImage('assets/image_profile/michie.png')
                            as ImageProvider,
                    child: _image == null
                        ? Icon(Icons.camera_alt,
                            color: Colors
                                .white) // Menampilkan ikon kamera jika belum memilih gambar
                        : null,
                  ),
                ),
                SizedBox(height: 20.0),

                // Kolom first name untuk edit
                TextField(
                  controller: firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12.0),

                // Kolom last name untuk edit
                TextField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12.0),

                // Kolom password untuk edit
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12.0),

                // Kolom birthdate untuk edit
                TextField(
                  controller: birthdateController,
                  decoration: InputDecoration(
                    labelText: 'Birthdate',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12.0),

                // Kolom email untuk edit
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20.0),

                // Tombol simpan perubahan
                ElevatedButton(
                  onPressed: () {
                    // Proses untuk menyimpan data yang sudah diubah
                    String firstName = firstNameController.text;
                    String lastName = lastNameController.text;
                    String password = passwordController.text;
                    String birthdate = birthdateController.text;
                    String email = emailController.text;

                    // Menampilkan data yang sudah diubah
                    print(
                        'Updated Data: $firstName, $lastName, $password, $birthdate, $email');

                    // Kembali ke halaman sebelumnya (Detail Profile Page)
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
                    backgroundColor:
                        Color(0xff97CBFB), // Warna latar belakang tombol
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text('Save Changes', style: TextStyle(fontSize: 16.0)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
