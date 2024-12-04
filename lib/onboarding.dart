import 'package:flutter/material.dart';
import 'login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: OnboardingPage());
  }
}

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  // Controller untuk PageView
  final PageController _pageController = PageController();

  // Menyimpan index aktif
  int _currentIndex = 0;

  // Daftar gambar untuk carousel
  final List<String> _images = [
    'assets/mood_track.png',
    'assets/chatbot.png',
    'assets/blog.png',
    'assets/relaxation.png',
    'assets/self_asses.png',
  ];

  // Daftar deskripsi tambahan untuk setiap halaman
  final List<String> _additionalDescriptions = [
    'Track your mood',
    'Chat with AI',
    'Information Blog',
    'Relaxation Activity',
    'Self Assesment',
  ];

  // Daftar deskripsi utama untuk setiap halaman
  final List<String> _descriptions = [
    'Identify and record your mood status.',
    'Confide your feelings with us.',
    'Get inspired with parenting knowledge.',
    'Calm and stabilize your mood with us.',
    'Calm and stabilize your mood with us.',
  ];

  // Fungsi untuk berpindah halaman ke halaman selanjutnya
  void _nextPage() {
    if (_currentIndex < _images.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Jika di halaman terakhir, navigasi ke halaman login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  // Fungsi untuk melompat langsung ke halaman terakhir (Skip)
  void _MoveToLoginPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Logo tetap berada di atas
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Container(
              width: 100, // Atur lebar logo
              height: 100, // Atur tinggi logo
              child: Image.asset(
                'assets/logo.png', // Path logo Anda
                fit: BoxFit.contain, // Pastikan logo tidak terpotong
              ),
            ),
          ),

          // Carousel menggunakan PageView
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _images.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Gambar onboarding
                    Container(
                      width: double.infinity,
                      height: 270, // Ukuran tinggi gambar
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(_images[index]),
                          fit:
                              BoxFit
                                  .contain, // Menjaga gambar tetap proporsional
                        ),
                      ),
                    ),
                    SizedBox(height: 8),

                    // Teks Deskripsi
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          // Deskripsi tambahan
                          Text(
                            _additionalDescriptions[index],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Color(0xff324D81),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8),
                          // Deskripsi utama
                          Text(
                            _descriptions[index],
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Color(0xff657AA1),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // Line Indicator (Garis) dengan animasi dot
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_images.length, (index) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  height: 4.0, // Ukuran tinggi garis
                  width:
                      _currentIndex == index
                          ? 20.0 // Lebar garis aktif lebih panjang
                          : 15.0, // Lebar garis tidak aktif
                  decoration: BoxDecoration(
                    color:
                        _currentIndex == index
                            ? Color(0xff324D81)
                            : Colors.grey,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                );
              }),
            ),
          ),

          SizedBox(height: 20),

          // Tombol Next dan Skip
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _nextPage,
                      child: Text(
                        'Next',
                        style: TextStyle(
                          color: Color(0xffffffff),
                          fontWeight: FontWeight.w900,
                          fontSize: 17,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color(0xff6495ED),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                        minimumSize: MaterialStateProperty.all(Size(300, 50)),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _MoveToLoginPage,
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: Color(0xff324D81),
                          fontWeight: FontWeight.w900,
                          fontSize: 17,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color(0xffffffff),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                side: BorderSide(
                                  color: Color(0xffFFBCD9),
                                  width: 2,
                                ),
                              ),
                            ),
                        minimumSize: MaterialStateProperty.all(Size(300, 50)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
