import 'dart:convert';

import 'package:flutter/material.dart';

import 'login.dart';
import 'services/api_service.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign Up Page',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SignUpPage(),
    );
  }
}

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _obscurePassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  Future<void> _handleRegister() async {
    // if (_passwordController.text != _confirmPasswordController.text) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Passwords do not match')),
    //   );
    //   return;
    // }

    setState(() {
      _isLoading = true;
    });

    final userData = {
      'idUser': "0",
      'namaDpn': _firstNameController.text,
      'namaBlkg': _lastNameController.text,
      'passUsr': _passwordController.text,
      'passUsr_confirmation': _passwordController.text,
      // 'tglLahir': _tglLahirController.text,
      'tglLahir': "2000-01-01",
      'email': _emailController.text,
    };

    // Convert to JSON string
    final jsonString = jsonEncode(userData);
    
    // Print to console
    print('JSON Format: $jsonString');

    final result = await _apiService.register(userData);

    setState(() {
      _isLoading = false;
    });

    if (result['success']) {
      // Registrasi berhasil
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign Up berhasil'),
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      ); // Kembali ke halaman login
    } else {
      // Registrasi gagal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Registration failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: <Widget>[
              // Logo dengan margin untuk jarak
              Padding(
                padding: const EdgeInsets.only(
                  top: 30.0,
                ), // Menambahkan jarak atas
                child: Image.asset('assets/logo.png', height: 76),
              ),
              SizedBox(height: 45),

              // Judul
              Container(
                constraints: BoxConstraints(maxWidth: 300),
                alignment: Alignment.center,
                child: Text(
                  'Welcome to momEase',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff324D81),
                  ),
                ),
              ),
              SizedBox(height: 8),

              // Subjudul
              Container(
                constraints: BoxConstraints(maxWidth: 300),
                alignment: Alignment.center,
                child: Text(
                  'Regist your account bellow to manage and access all of our features',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF657AA1),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 60),

              // Form untuk validasi
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Kolom input First Name
                    TextFormField(
                      controller: _firstNameController,
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        prefixIcon: Icon(Icons.person_outline),
                        prefixIconConstraints: BoxConstraints(minWidth: 60),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color(0xff1B3C73),
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey, width: 1),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your first name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),

                    // Kolom input Last Name
                    TextFormField(
                      controller: _lastNameController,
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        prefixIcon: Icon(Icons.person),
                        prefixIconConstraints: BoxConstraints(minWidth: 60),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color(0xff1B3C73),
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey, width: 1),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your last name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),

                    // Kolom input email
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                        prefixIconConstraints: BoxConstraints(minWidth: 60),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color(0xff1B3C73),
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey, width: 1),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),

                    // Kolom input password
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock_outline),
                        prefixIconConstraints: BoxConstraints(minWidth: 60),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        suffixIconConstraints: BoxConstraints(minWidth: 50),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color(0xff1B3C73),
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey, width: 1),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 90),

                    // Tombol Sign Up
                    ElevatedButton(
                      onPressed: _handleRegister,
                      // onPressed: () {
                      //   if (_formKey.currentState!.validate()) {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => LoginPage(),
                      //       ),
                      //     );
                      //   }
                      // },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Color(0xffffffff),
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        backgroundColor: Color(0xff6495ED),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    // Teks "Already have an account?"
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: TextStyle(
                            color: Color(0xff1B3C73),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Click here',
                            style: TextStyle(
                              color: Color(0xffFFBCD9),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
