import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_end/blogs.dart';
import 'package:front_end/chatbot.dart';
import 'package:front_end/mood_journaling.dart';
import 'package:front_end/profile.dart';
import 'package:front_end/relaxation.dart';
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
            // Menggunakan font Poppins di seluruh aplikasi
            textTheme: GoogleFonts.poppinsTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            '/': (context) => SplashScreen(),
            '/chatbot': (context) => ChatBotPage(),
            '/relaxation': (context) => RelaxationPage(),
            '/mood_journaling': (context) => MoodJournaling(),
            '/blogs': (context) => BlogsPage(),
            '/profile': (context) => ProfilePage(),
          },
        );
      },
    );
  }
}
