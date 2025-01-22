import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // Add this package to pubspec.yaml

class DetailProfilePage extends StatefulWidget {
  @override
  _DetailProfilePageState createState() => _DetailProfilePageState();
}

class _DetailProfilePageState extends State<DetailProfilePage> {
  final TextEditingController namaDpnController = TextEditingController();
  final TextEditingController namaBlkgController = TextEditingController();
  final TextEditingController tglLahirController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  
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
        Uri.parse('http://127.0.0.1:8000/api/user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final userData = responseData['data'];
        
        setState(() {
          namaDpnController.text = userData['namaDpn'] ?? '';
          namaBlkgController.text = userData['namaBlkg'] ?? '';
          tglLahirController.text = userData['tglLahir'] ?? '';
          emailController.text = userData['email'] ?? '';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
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
                        'Error loading profile',
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
              : SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50.0,
                        backgroundColor: Colors.grey[200],
                        child: Icon(Icons.person, size: 50, color: Colors.grey[400]),
                      ),
                      SizedBox(height: 24.0),
                      
                      ProfileInfoField(
                        controller: namaDpnController,
                        label: 'Nama Depan',
                        readOnly: true,
                      ),
                      SizedBox(height: 16.0),
                      
                      ProfileInfoField(
                        controller: namaBlkgController,
                        label: 'Nama Belakang',
                        readOnly: true,
                      ),
                      SizedBox(height: 16.0),
                      
                      ProfileInfoField(
                        controller: tglLahirController,
                        label: 'Tanggal Lahir',
                        readOnly: true,
                      ),
                      SizedBox(height: 16.0),
                      
                      ProfileInfoField(
                        controller: emailController,
                        label: 'Email',
                        readOnly: true,
                      ),
                    ],
                  ),
                ),
    );
  }

  @override
  void dispose() {
    namaDpnController.dispose();
    namaBlkgController.dispose();
    tglLahirController.dispose();
    emailController.dispose();
    super.dispose();
  }
}

class ProfileInfoField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool readOnly;

  const ProfileInfoField({
    required this.controller,
    required this.label,
    this.readOnly = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: readOnly,
        fillColor: Colors.grey[100],
      ),
    );
  }
}