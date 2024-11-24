import 'package:flutter/material.dart';
import 'dart:async';
import 'package:front_end/login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6495ED),
      body: Center(
        child: Image.asset(
          'assets/logo.png', // Path gambar logo
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Logo di tengah paling atas
          Padding(
            padding: const EdgeInsets.only(
              top: 40,
            ), // Memberikan jarak dari atas
            child: Center(
              child: Image.asset(
                'assets/logo.png', // Path untuk gambar logo
                width: 165,
                height: 165,
              ),
            ),
          ),

          // Konten lainnya
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Mengatur ukuran kolom sesuai isi
                children: [
                  // Gambar biasa
                  Image.asset(
                    'assets/shop-car.png', // Path untuk gambar biasa
                    width: 250,
                    height: 200,
                  ),
                  const SizedBox(
                    height: 40,
                  ), // Spasi antara gambar biasa dan teks
                  // Teks di bawah gambar biasa
                  const Text(
                    'Make it simple to buy',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Click and purchase just by one click',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF808080),
                    ),
                  ),

                  const SizedBox(height: 55),

                  // Button
                  HoverButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WelcomePage2()),
                      );
                    },
                    backgroundColor: Color(0xFFFE0000),
                    hoverColor: Color(0xFF000000),
                    textColor: Color(0xff000000),
                    hoverTextColor: Color(0xFFffffff),
                    borderColor: Color(0xFF000000),
                    hoverBorderColor: Color(0xFFFE0000),
                    text: 'Next',
                  ),
                  const SizedBox(height: 15), // Spasi antar tombol
                  HoverButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    backgroundColor: Color(0xFFffffff),
                    hoverColor: Color(0xFF000000),
                    textColor: Color(0xff000000),
                    hoverTextColor: Color(0xFFffffff),
                    borderColor: Color(0xFF000000),
                    hoverBorderColor: Color(0xFF000000),
                    text: 'Skip',
                  ),
                  const SizedBox(height: 50), // Spasi antara teks dan tombol
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WelcomePage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Logo di tengah paling atas
          Padding(
            padding: const EdgeInsets.only(
              top: 40,
            ), // Memberikan jarak dari atas
            child: Center(
              child: Image.asset(
                'assets/logo.png', // Path untuk gambar logo
                width: 165,
                height: 165,
              ),
            ),
          ),

          // Konten lainnya
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Mengatur ukuran kolom sesuai isi
                children: [
                  // Gambar biasa
                  Image.asset(
                    'assets/details-car.png', // Path untuk gambar biasa
                    width: 250,
                    height: 200,
                  ),
                  const SizedBox(
                    height: 40,
                  ), // Spasi antara gambar biasa dan teks
                  // Teks di bawah gambar biasa
                  const Text(
                    'Enjoy every details',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Imagine having cool cars by seeing the details',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF808080),
                    ),
                  ),

                  const SizedBox(height: 55),

                  // Button
                  HoverButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WelcomePage3()),
                      );
                    },
                    backgroundColor: Color(0xFFFE0000),
                    hoverColor: Color(0xFF000000),
                    textColor: Color(0xff000000),
                    hoverTextColor: Color(0xFFffffff),
                    borderColor: Color(0xFF000000),
                    hoverBorderColor: Color(0xFFFE0000),
                    text: 'Next',
                  ),
                  const SizedBox(height: 15), // Spasi antar tombol
                  HoverButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    backgroundColor: Color(0xFFffffff),
                    hoverColor: Color(0xFF000000),
                    textColor: Color(0xff000000),
                    hoverTextColor: Color(0xFFffffff),
                    borderColor: Color(0xFF000000),
                    hoverBorderColor: Color(0xFF000000),
                    text: 'Skip',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WelcomePage3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Logo di tengah paling atas
          Padding(
            padding: const EdgeInsets.only(
              top: 40,
            ), // Memberikan jarak dari atas
            child: Center(
              child: Image.asset(
                'assets/logo.png', // Path untuk gambar logo
                width: 165,
                height: 165,
              ),
            ),
          ),

          // Konten lainnya
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Mengatur ukuran kolom sesuai isi
                children: [
                  // Gambar biasa
                  Image.asset(
                    'assets/collection-car.png', // Path untuk gambar biasa
                    width: 250,
                    height: 200,
                  ),
                  const SizedBox(
                    height: 40,
                  ), // Spasi antara gambar biasa dan teks
                  // Teks di bawah gambar biasa
                  const Text(
                    'Collect every cars',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "One car isn't enough, collect something new",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF808080),
                    ),
                  ),

                  const SizedBox(height: 55),

                  // Button
                  HoverButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    backgroundColor: Color(0xFFFE0000),
                    hoverColor: Color(0xFF000000),
                    textColor: Color(0xff000000),
                    hoverTextColor: Color(0xFFffffff),
                    borderColor: Color(0xFF000000),
                    hoverBorderColor: Color(0xFFFE0000),
                    text: 'Next',
                  ),
                  const SizedBox(height: 15), // Spasi antar tombol
                  HoverButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    backgroundColor: Color(0xFFffffff),
                    hoverColor: Color(0xFF000000),
                    textColor: Color(0xff000000),
                    hoverTextColor: Color(0xFFffffff),
                    borderColor: Color(0xFF000000),
                    hoverBorderColor: Color(0xFF000000),
                    text: 'Skip',
                  ),
                ],
              ),
            ),
          ),
        ],
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
