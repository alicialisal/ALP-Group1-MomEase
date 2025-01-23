import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:front_end/profile/edit_profile.dart';

class DetailProfilePage extends StatefulWidget {
  @override
  _DetailProfilePageState createState() => _DetailProfilePageState();
}

class _DetailProfilePageState extends State<DetailProfilePage> {
  String firstName = '';
  String lastName = '';
  String birthdate = '';
  String email = '';
  String? profileImageUrl; // Tambahkan variabel untuk URL gambar profil

  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> fetchUserProfile() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/profile/show'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('API Response: $responseData');
        success(responseData);
      } else if (response.statusCode == 401) {
        setState(() {
          error = 'Unauthorized: Please login again.';
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Failed to load profile data: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void success(Map<String, dynamic> responseData) {
    final userData = responseData['profile'];

    setState(() {
      firstName = userData['namaDpn'] ?? '';
      lastName = userData['namaBlkg'] ?? '';
      birthdate = userData['tglLahir'] ?? '';
      email = userData['email'] ?? '';
      profileImageUrl = userData['profile_image']; // Ambil URL gambar profil
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Profile'),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        error!,
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      TextButton(
                        onPressed: fetchUserProfile,
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // // Gambar profil
                      // Center(
                      //   child: CircleAvatar(
                      //     radius: 50.0,
                      //     backgroundImage: profileImageUrl != null
                      //         ? NetworkImage(profileImageUrl!)
                      //         : AssetImage(
                      //                 'assets/image_profile/michie.png') // Gambar default jika URL null
                      //             as ImageProvider,
                      //   ),
                      // ),
                      // SizedBox(height: 20.0),

                      // Data profil dalam TextField (tidak bisa diedit)
                      _buildReadOnlyTextField('First Name', firstName),
                      SizedBox(height: 12.0),
                      _buildReadOnlyTextField('Last Name', lastName),
                      SizedBox(height: 12.0),
                      _buildReadOnlyTextField('Birthdate', birthdate),
                      SizedBox(height: 12.0),
                      _buildReadOnlyTextField('Email', email),
                      SizedBox(height: 20.0),

                      // Tombol Edit Profile
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfilePage()),
                          ).then((_) {
                            // Memuat ulang data profil setelah kembali dari EditProfilePage
                            fetchUserProfile();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 14.0, horizontal: 24.0),
                          backgroundColor: Color(0xff97CBFB),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Text('Edit Profile',
                            style: TextStyle(fontSize: 16.0)),
                      ),
                    ],
                  ),
                ),
    );
  }

  // Helper function untuk membuat TextField read-only
  Widget _buildReadOnlyTextField(String label, String value) {
    return TextField(
      controller: TextEditingController(text: value),
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        // Menghilangkan ikon pensil (suffixIcon)
      ),
    );
  }
}