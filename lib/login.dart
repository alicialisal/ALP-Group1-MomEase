import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang halaman login
      body: Padding(
        padding: const EdgeInsets.all(20.0), // Padding untuk seluruh body
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Memusatkan kolom
          crossAxisAlignment:
              CrossAxisAlignment.center, // Memusatkan secara horizontal
          children: [
            // Logo di bagian atas
            Image.asset(
              'assets/logo.jpg', // Path untuk gambar logo
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 10), // Spasi setelah logo
            // Title bold di bawah logo
            const Text(
              'Welcome to LB.Works',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10), // Spasi setelah title
            // Teks normal di bawah title
            const Text(
              'Get back to your account before facing the real global trendy cars',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Color(0xFF808080),
              ),
            ),
            const SizedBox(height: 50), // Spasi setelah teks normal
            // Kolom input untuk Username
            TextField(
              decoration: InputDecoration(
                labelText: 'Username',
                labelStyle: TextStyle(color: Color(0xFF808080)),
                floatingLabelStyle: TextStyle(color: Color(0xFFFE0000)),
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF000000), width: 2.0),
                  borderRadius: BorderRadius.circular(0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF808080), width: 1.5),
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
            ),
            const SizedBox(height: 30), // Spasi antara kolom input
            // Kolom input untuk Password
            TextField(
              obscureText: true, // Menyembunyikan teks untuk password
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Color(0xFF808080)),
                floatingLabelStyle: TextStyle(color: Color(0xFFFE0000)),
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF000000), width: 2.0),
                  borderRadius: BorderRadius.circular(0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF808080), width: 1.5),
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
            ),
            const SizedBox(height: 120), // Spasi setelah input field
            // Tombol Login
            HoverButton(
              onPressed: () {},
              backgroundColor: Color(0xFFFE0000),
              hoverColor: Color(0xFF000000),
              textColor: Color(0xff000000),
              hoverTextColor: Color(0xFFffffff),
              borderColor: Color(0xFF000000),
              hoverBorderColor: Color(0xFFFE0000),
              text: 'Login',
            ),
          ],
        ),
      ),
    );
  }
}

class HoverButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color hoverColor;
  final Color textColor;
  final Color hoverTextColor;
  final Color borderColor;
  final Color hoverBorderColor;
  final double borderWidth;

  const HoverButton({
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.red,
    this.hoverColor = Colors.grey,
    this.textColor = Colors.white,
    this.hoverTextColor = Colors.black,
    this.borderColor = Colors.black,
    this.hoverBorderColor = Colors.white,
    this.borderWidth = 2.0,
    Key? key,
  }) : super(key: key);

  @override
  _HoverButtonState createState() => _HoverButtonState();
}

class _HoverButtonState extends State<HoverButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              _isHovering ? widget.hoverColor : widget.backgroundColor,
          foregroundColor:
              _isHovering ? widget.hoverTextColor : widget.textColor,
          padding: const EdgeInsets.symmetric(horizontal: 155, vertical: 17),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          side: BorderSide(
            color: _isHovering ? widget.hoverBorderColor : widget.borderColor,
            width: widget.borderWidth,
          ),
        ),
        child: Text(
          widget.text,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.normal),
        ),
      ),
    );
  }
}
