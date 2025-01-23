import 'package:flutter/material.dart';
import 'package:front_end/navbar/custom_navbar.dart';
import 'package:front_end/notification/notification.dart';
import 'package:front_end/profile/detail_profile.dart';
import 'package:front_end/self-assesment/start_screen.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
        centerTitle: true,
        automaticallyImplyLeading: false, // Menghapus ikon back default

        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined), // Ikon notifikasi
            onPressed: () {
              // Arahkan ke halaman Notifikasi
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationPage()),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Button menuju halaman detail profile
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailProfilePage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 16.0),
                          backgroundColor: Color(0xff97CBFB),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween, // Mengatur posisi konten
                          children: [
                            Text(
                              'My profile',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            // Ikon panah ke kanan
                            Icon(
                              Icons.arrow_forward_ios, // Panah ke kanan
                              color: Colors.white,
                              size: 18.0, // Ukuran ikon
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 16.0),

                      // Button menuju halaman self assessment
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StartScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 16.0),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side:
                                BorderSide(color: Color(0xffFFBCD9), width: 3),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Text
                            Text(
                              'Self Assessment',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Color(0xff000000),
                                  fontWeight: FontWeight.w600),
                            ),
                            // Gambar
                            Image.asset(
                              'assets/images/self_asses.png',
                              width: 80.0,
                              height: 80.0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Button Logout
              ElevatedButton(
                onPressed: () {
                  // Logika logout
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 45),
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Colors.red, width: 2),
                  ),
                ),
                child: Text(
                  'Logout',
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.red,
                      fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomFloatingNavBar(
        selectedIndex: 4,
        onItemTapped: (index) {
          // Handle navigation based on the selected index
        },
      ),
    );
  }
}
