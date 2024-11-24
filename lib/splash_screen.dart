import 'package:flutter/material.dart';
import 'dart:async';
import 'package:front_end/login.dart';
import 'package:google_fonts/google_fonts.dart';

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
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFffffff),
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
                width: 105,
                height: 105,
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
                    'assets/mood_track.png', // Path untuk gambar biasa
                    width: 250,
                    height: 200,
                  ),
                  const SizedBox(
                    height: 40,
                  ), // Spasi antara gambar biasa dan teks
                  // Teks di bawah gambar biasa
                  Text(
                    'Track your mood',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF324D81),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Identify and record your mood status',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF657AA1),
                    ),
                  ),

                  const SizedBox(height: 135),

                  // Button
                  HoverButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WelcomePage2()),
                      );
                    },
                    backgroundColor: Color(0xFF6495ED),
                    hoverColor: Color(0xffffffff),
                    textColor: Color(0xFFffffff),
                    hoverTextColor: Color(0xFF6495ED),
                    borderColor: Color(0xFF6495ED),
                    hoverBorderColor: Color(0xFF6495ED),
                    text: 'Next',
                    borderRadius: 10.0, // Radius sudut
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
                    hoverColor: Color(0xff324D81),
                    textColor: Color(0xff324D81),
                    hoverTextColor: Color(0xFFffffff),
                    borderColor: Color(0xFFFFBCD9),
                    hoverBorderColor: Color(0xFFFFBCD9),
                    text: 'Skip',
                    borderRadius: 10.0, // Radius sudut
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
      backgroundColor: Color(0xFFffffff),
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
                width: 105,
                height: 105,
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
                    'assets/chatbot.png', // Path untuk gambar biasa
                    width: 250,
                    height: 200,
                  ),
                  const SizedBox(
                    height: 40,
                  ), // Spasi antara gambar biasa dan teks
                  // Teks di bawah gambar biasa
                  Text(
                    'Chat with AI',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF324D81),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Confide your feeling with us',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF657AA1),
                    ),
                  ),

                  const SizedBox(height: 135),

                  // Button
                  HoverButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WelcomePage3()),
                      );
                    },
                    backgroundColor: Color(0xFF6495ED),
                    hoverColor: Color(0xffffffff),
                    textColor: Color(0xFFffffff),
                    hoverTextColor: Color(0xFF6495ED),
                    borderColor: Color(0xFF6495ED),
                    hoverBorderColor: Color(0xFF6495ED),
                    text: 'Next',
                    borderRadius: 10.0, // Radius sudut
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
                    hoverColor: Color(0xff324D81),
                    textColor: Color(0xff324D81),
                    hoverTextColor: Color(0xFFffffff),
                    borderColor: Color(0xFFFFBCD9),
                    hoverBorderColor: Color(0xFFFFBCD9),
                    text: 'Skip',
                    borderRadius: 10.0, // Radius sudut
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

class WelcomePage3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFffffff),
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
                width: 105,
                height: 105,
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
                    'assets/blog.png', // Path untuk gambar biasa
                    width: 250,
                    height: 200,
                  ),
                  const SizedBox(
                    height: 40,
                  ), // Spasi antara gambar biasa dan teks
                  // Teks di bawah gambar biasa
                  Text(
                    'Information Blog',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF324D81),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Get inspired with parenting knowledge',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF657AA1),
                    ),
                  ),

                  const SizedBox(height: 135),

                  // Button
                  HoverButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WelcomePage4()),
                      );
                    },
                    backgroundColor: Color(0xFF6495ED),
                    hoverColor: Color(0xffffffff),
                    textColor: Color(0xFFffffff),
                    hoverTextColor: Color(0xFF6495ED),
                    borderColor: Color(0xFF6495ED),
                    hoverBorderColor: Color(0xFF6495ED),
                    text: 'Next',
                    borderRadius: 10.0, // Radius sudut
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
                    hoverColor: Color(0xff324D81),
                    textColor: Color(0xff324D81),
                    hoverTextColor: Color(0xFFffffff),
                    borderColor: Color(0xFFFFBCD9),
                    hoverBorderColor: Color(0xFFFFBCD9),
                    text: 'Skip',
                    borderRadius: 10.0, // Radius sudut
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

class WelcomePage4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFffffff),
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
                width: 105,
                height: 105,
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
                    'assets/relaxation.png', // Path untuk gambar biasa
                    width: 250,
                    height: 200,
                  ),
                  const SizedBox(
                    height: 40,
                  ), // Spasi antara gambar biasa dan teks
                  // Teks di bawah gambar biasa
                  Text(
                    'Relaxation Activity',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF324D81),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Calm and stabilize your mood with us',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF657AA1),
                    ),
                  ),

                  const SizedBox(height: 135),

                  // Button
                  HoverButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WelcomePage5()),
                      );
                    },
                    backgroundColor: Color(0xFF6495ED),
                    hoverColor: Color(0xffffffff),
                    textColor: Color(0xFFffffff),
                    hoverTextColor: Color(0xFF6495ED),
                    borderColor: Color(0xFF6495ED),
                    hoverBorderColor: Color(0xFF6495ED),
                    text: 'Next',
                    borderRadius: 10.0, // Radius sudut
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
                    hoverColor: Color(0xff324D81),
                    textColor: Color(0xff324D81),
                    hoverTextColor: Color(0xFFffffff),
                    borderColor: Color(0xFFFFBCD9),
                    hoverBorderColor: Color(0xFFFFBCD9),
                    text: 'Skip',
                    borderRadius: 10.0, // Radius sudut
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

class WelcomePage5 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFffffff),
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
                width: 105,
                height: 105,
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
                    'assets/self_asses.png', // Path untuk gambar biasa
                    width: 250,
                    height: 200,
                  ),
                  const SizedBox(
                    height: 40,
                  ), // Spasi antara gambar biasa dan teks
                  // Teks di bawah gambar biasa
                  Text(
                    'Self Assesment',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF324D81),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Test your inner feeling',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF657AA1),
                    ),
                  ),

                  const SizedBox(height: 135),

                  // Button
                  HoverButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    backgroundColor: Color(0xFF6495ED),
                    hoverColor: Color(0xffffffff),
                    textColor: Color(0xFFffffff),
                    hoverTextColor: Color(0xFF6495ED),
                    borderColor: Color(0xFF6495ED),
                    hoverBorderColor: Color(0xFF6495ED),
                    text: 'Next',
                    borderRadius: 10.0, // Radius sudut
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
                    hoverColor: Color(0xff324D81),
                    textColor: Color(0xff324D81),
                    hoverTextColor: Color(0xFFffffff),
                    borderColor: Color(0xFFFFBCD9),
                    hoverBorderColor: Color(0xFFFFBCD9),
                    text: 'Skip',
                    borderRadius: 10.0, // Radius sudut
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
  final double borderRadius;

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
    this.borderRadius = 10,
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
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
