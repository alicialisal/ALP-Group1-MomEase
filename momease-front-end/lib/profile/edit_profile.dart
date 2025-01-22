import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    try {
      setState(() => _isInitializing = true);
      
      // Add a getProfile method to your ApiService that fetches the current profile
      final response = await _apiService.getProfile();
      
      if (response['success']) {
        final profile = response['profile'];
        setState(() {
          firstNameController.text = profile['namaDpn'] ?? '';
          lastNameController.text = profile['namaBlkg'] ?? '';
          birthdateController.text = profile['tglLahir'] ?? '';
          emailController.text = profile['email'] ?? '';
        });
      } else {
        _showErrorSnackbar('Failed to load profile data');
      }
    } catch (e) {
      _showErrorSnackbar('Error loading profile data');
    } finally {
      setState(() => _isInitializing = false);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    
    if (picked != null) {
      setState(() {
        birthdateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _updateProfile() async {
    if (!_validateInputs()) return;

    setState(() => _isLoading = true);

    try {
      final profileData = {
        'namaDpn': firstNameController.text,
        'namaBlkg': lastNameController.text,
        'tglLahir': birthdateController.text,
        'email': emailController.text,
      };

      final response = await _apiService.updateProfile(profileData);

      if (response['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Profile updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Pass true to indicate successful update
      } else {
        _showErrorSnackbar(response['message'] ?? 'Failed to update profile');
      }
    } catch (e) {
      _showErrorSnackbar('Failed to update profile');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  bool _validateInputs() {
    if (firstNameController.text.isEmpty) {
      _showErrorSnackbar('First name is required');
      return false;
    }
    if (emailController.text.isEmpty || !emailController.text.contains('@')) {
      _showErrorSnackbar('Valid email is required');
      return false;
    }
    if (birthdateController.text.isEmpty) {
      _showErrorSnackbar('Birthdate is required');
      return false;
    }
    return true;
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false), // Pass false if no update
        ),
      ),
      body: _isInitializing
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: firstNameController,
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: lastNameController,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextField(
                        controller: birthdateController,
                        decoration: InputDecoration(
                          labelText: 'Birthdate',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _updateProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff97CBFB),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      _isLoading ? 'Updating...' : 'Save Changes',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    birthdateController.dispose();
    emailController.dispose();
    super.dispose();
  }
}