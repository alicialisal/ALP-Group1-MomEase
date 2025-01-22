import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:front_end/services/api_service.dart'; 

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  File? _image;
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final profileData = await _apiService.getProfile();
      if (profileData['success']) {
        final profile = profileData['profile'];
        firstNameController.text = profile['namaDpn'];
        lastNameController.text = profile['namaBlkg'];
        birthdateController.text = profile['tglLahir'];
        emailController.text = profile['email'];
      } else {
        _showErrorSnackbar(profileData['message']);
      }
    } catch (e) {
      _showErrorSnackbar('Failed to load profile data.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateProfile() async {
    setState(() {
      _isLoading = true;
    });

    String firstName = firstNameController.text;
    String lastName = lastNameController.text;
    String birthdate = birthdateController.text;
    String email = emailController.text;

    try {
      FormData formData = FormData.fromMap({
        'namaDpn': firstName,
        'namaBlkg': lastName,
        'tglLahir': birthdate,
        'email': email,
      });

      final response = await _apiService.updateProfile(formData);

      if (response['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.pop(context);
      } else {
        _showErrorSnackbar(response['message']);
      }
    } catch (e) {
      _showErrorSnackbar('Failed to update profile.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
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
          child: _isLoading
              ? CircularProgressIndicator()
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundImage: _image != null
                              ? FileImage(_image!)
                              : AssetImage(
                                  'assets/image_profile/michie.png') // Gambar default
                              as ImageProvider,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      TextField(
                        controller: firstNameController,
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 12.0),
                      TextField(
                        controller: lastNameController,
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 12.0),
                      TextField(
                        controller: birthdateController,
                        decoration: InputDecoration(
                          labelText: 'Birthdate',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 12.0),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: _updateProfile,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 14.0, horizontal: 24.0),
                          backgroundColor: Color(0xff97CBFB),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Text('Save Changes',
                            style: TextStyle(fontSize: 16.0)),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}