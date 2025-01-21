import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_end/blog_page/blog.dart';
import 'package:front_end/chatbot.dart';
import 'package:front_end/edit_profile.dart';
import 'package:front_end/kegiatan_relaksasi/search_page.dart';
import 'package:front_end/mood_journaling.dart';
import 'package:google_fonts/google_fonts.dart';
import 'splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690), // Sesuaikan dengan desain dasar Anda
      minTextAdapt: true, // Agar ukuran teks menyesuaikan
      splitScreenMode: true, // Mendukung mode layar terpisah
      builder: (context, child) {
        return MaterialApp(
          theme: ThemeData(
            fontFamily: 'Poppins',
            textTheme: TextTheme(
              bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              bodyMedium: TextStyle(fontSize: 14),
              titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            '/': (context) => SplashScreen(),
            '/chatbot': (context) => ChatBotPage(),
            '/relaxation': (context) => RelaxationApp(),
            '/mood_journaling': (context) => MoodJournaling(),
            '/blogs': (context) => BlogPage(),
            '/profile': (context) => ProfileView(),
          },
        );
      },
    );
  }
}
