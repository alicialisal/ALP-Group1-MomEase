import 'package:flutter/material.dart';

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
  bool _obscurePassword = true; // Variabel untuk hide/unhide password
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 35),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // Logo
                Image.asset(
                  'assets/logo.png',
                  height: 75,
                ), // Ganti dengan path logo Anda
                SizedBox(height: 45),

                // Judul
                Container(
                  constraints: BoxConstraints(
                    maxWidth: 300,
                  ), // Atur lebar maksimum
                  alignment: Alignment.center, // Posisikan teks ke tengah
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

                // Kolom input First Name
                TextField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    prefixIcon: Icon(Icons.person_outline),
                    prefixIconConstraints: BoxConstraints(
                      minWidth: 60, // Memberi ruang untuk ikon
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10), // Radius border
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Color(0xff1B3C73),
                        width: 2,
                      ), // Warna saat fokus
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1,
                      ), // Warna default
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Kolom input Last Name
                TextField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    prefixIcon: Icon(Icons.person),
                    prefixIconConstraints: BoxConstraints(
                      minWidth: 60, // Memberi ruang untuk ikon
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10), // Radius border
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Color(0xff1B3C73),
                        width: 2,
                      ), // Warna saat fokus
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1,
                      ), // Warna default
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Kolom input email
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    prefixIconConstraints: BoxConstraints(
                      minWidth: 60, // Memberi ruang untuk ikon
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10), // Radius border
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Color(0xff1B3C73),
                        width: 2,
                      ), // Warna saat fokus
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1,
                      ), // Warna default
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Kolom input password
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline),
                    prefixIconConstraints: BoxConstraints(
                      minWidth: 60, // Memberi ruang untuk ikon
                    ),
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
                    suffixIconConstraints: BoxConstraints(
                      minWidth: 50, // Geser ikon kanan juga
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10), // Radius border
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Color(0xff1B3C73),
                        width: 2,
                      ), // Warna saat fokus
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1,
                      ), // Warna default
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                  ),
                ),
                SizedBox(height: 90),

                // Tombol Sign Up
                ElevatedButton(
                  onPressed: () {
                    // Implementasikan sign-up logic Anda di sini
                    print('First Name: ${_firstNameController.text}');
                    print('Last Name: ${_lastNameController.text}');
                    print('Email: ${_emailController.text}');
                    print('Password: ${_passwordController.text}');
                  },
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
                        // Navigasi ke halaman Login
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
        ),
      ),
    );
  }
}
