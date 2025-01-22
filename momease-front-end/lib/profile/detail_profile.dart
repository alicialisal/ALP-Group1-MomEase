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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                      ),
                      SizedBox(height: 20.0),
                      Text('First Name: $firstName',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8.0),
                      Text('Last Name: $lastName',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8.0),
                      Text('Birthdate: $birthdate',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8.0),
                      Text('Email: $email',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold)),
                      SizedBox(height: 20.0), // Add spacing
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigasi ke halaman EditProfilePage
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfilePage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff97CBFB), // Warna background
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                          ),
                          child: Text('Edit Profile',
                              style: TextStyle(fontSize: 16.0)),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}