import 'package:flutter/material.dart';
import 'package:front_end/kegiatan_relaksasi/timer_activity_page.dart';
import 'dart:ui';

class DetailScreen extends StatelessWidget {
  final String title;
  final String duration;
  final String benefit;
  final String category;
  final String image;
  final Color categoryColor;
  final String description;

  DetailScreen({
    required this.title,
    required this.duration,
    required this.benefit,
    required this.category,
    required this.image,
    required this.categoryColor,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Activities'),
        backgroundColor: Color(0xffffffff),
        centerTitle: true,
      ),
      body: Container(
        color: Color(0xFFffffff),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Konten di bagian atas (title, duration, image, dsb)
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Title and Duration
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time, // Icon untuk durasi
                                      size: 16.0,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(
                                      width: 4.0,
                                    ), // Spasi antara icon dan text
                                    Text(
                                      duration,
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 6.0,
                              horizontal: 10.0,
                            ),
                            decoration: BoxDecoration(
                              color: categoryColor,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Text(
                              category,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      // Image
                      Container(
                        height: 200.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          image: DecorationImage(
                            image: AssetImage(image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      // Benefit Description
                      Text(
                        "Benefits :",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        benefit,
                        style: TextStyle(fontSize: 14.0, height: 1.5),
                      ),

                      SizedBox(height: 16.0),

                      // Description Activity
                      Text(
                        "Description activity :",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        description,
                        style: TextStyle(fontSize: 14.0, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Spacer agar tombol berada di bawah layar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible:
                        true, // Modal bisa ditutup dengan klik di luar
                    builder: (BuildContext context) {
                      return BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 5,
                          sigmaY: 5,
                        ), // Blur background
                        child: AlertDialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          contentPadding: EdgeInsets.all(
                            16.0,
                          ), // Atur padding konten
                          content: Column(
                            mainAxisSize:
                                MainAxisSize.min, // Minimal tinggi konten
                            crossAxisAlignment:
                                CrossAxisAlignment.center, // Isi center
                            children: [
                              Text(
                                'Are you ready?',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 27,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 16.0),
                              Text(
                                'Timer will be start when you click start button',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF808080),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 24.0),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context); // Tutup modal
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RelaxationTimerPage(
                                        activity: {
                                          'title': title,
                                          'duration': duration,
                                          'benefit': benefit,
                                          'category': category,
                                          'image': image,
                                          'categoryColor': categoryColor,
                                          'description': description,
                                        },
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  minimumSize: Size(double.infinity, 45),
                                ),
                                child: Text(
                                  'Start!',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Text(
                  'Start',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xffffffff),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  backgroundColor: Color(0xff6495ED),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
