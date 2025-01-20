// import 'package:flutter/material.dart';

// class ProfilePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircleAvatar(
//               radius: 50,
//               backgroundColor: Colors.blueAccent,
//               child: Icon(
//                 Icons.person_outline,
//                 color: Colors.white,
//                 size: 50,
//               ),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'User Profile',
//               style: TextStyle(fontSize: 24),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Edit your details here.',
//               style: TextStyle(fontSize: 18),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String baseUrl = 'https://example.com/api'; // Ganti dengan URL backend Anda
  String? _message;
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _birthDateController = TextEditingController();

  // Fungsi untuk update profile
  Future<void> _updateProfile() async {
    final url = Uri.parse('$baseUrl/profile/update');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'idUser': 123,
          'namaDpn': _firstNameController.text,
          'namaBlkg': _lastNameController.text.isEmpty ? null : _lastNameController.text,
          'tglLahir': _birthDateController.text,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _message = 'Profile updated successfully!';
        });
      } else {
        final error = jsonDecode(response.body);
        setState(() {
          _message = 'Error: ${error['message']}';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Failed to update profile: $e';
      });
    }
  }

  // Fungsi untuk load data profile (optional)
  Future<void> _loadProfile() async {
    final url = Uri.parse('$baseUrl/profile');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _firstNameController.text = data['namaDpn'] ?? '';
          _lastNameController.text = data['namaBlkg'] ?? '';
          _birthDateController.text = data['tglLahir'] ?? '';
        });
      } else {
        setState(() {
          _message = 'Failed to load profile';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Error: $e';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueAccent,
              child: Icon(
                Icons.person_outline,
                color: Colors.white,
                size: 50,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'User Profile',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _birthDateController,
              decoration: InputDecoration(
                labelText: 'Date of Birth (YYYY-MM-DD)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateProfile,
              child: Text('Update Profile'),
            ),
            if (_message != null) ...[
              SizedBox(height: 20),
              Text(
                _message!,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
