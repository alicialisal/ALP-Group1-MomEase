import 'dart:io';

import 'package:flutter/material.dart';
import 'package:front_end/notification/notification.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DetailPage extends StatefulWidget {
  final DateTime date;
  final Map<String, dynamic> moodDetails;
  final String selectedEmote; // Menyimpan emote yang dipilih
  final String selectedMood; // Menyimpan status mood yang dipilih

  DetailPage({
    required this.date,
    required this.moodDetails,
    required this.selectedEmote,
    required this.selectedMood,
  });

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Map<String, dynamic> _moodDetails;

  @override
  void initState() {
    super.initState();
    _moodDetails = widget.moodDetails; // Inisialisasi awal
    _loadMoodData(); // Memuat data saat halaman pertama kali dibuka
  }

  Future<void> _loadMoodData() async {
    // final prefs = await SharedPreferences.getInstance();
    // final data =
    //     prefs.getString('moodData') ?? '{}'; // Ambil data yang ada, jika ada

    // setState(() {
    //   // Decode JSON dan transformasikan menjadi Map<DateTime, Map<String, dynamic>>
    //   _moodData = (jsonDecode(data) as Map<String, dynamic>)
    //       .map<DateTime, Map<String, dynamic>>((key, value) {
    //     // Mengkonversi string tanggal menjadi DateTime dan memastikan value menjadi Map<String, dynamic>
    //     return MapEntry(DateTime.parse(key), Map<String, dynamic>.from(value));
    //   });
    // });

    // try {
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   int? idUserActive = prefs.getInt('idUser');
    //   String? tokenActive = prefs.getString('token');
    //   // Validasi idUserActive
    //   if (idUserActive == null) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text('ID User tidak ditemukan. Silakan login kembali.')),
    //     );
    //     return;
    //   }

    //   if (tokenActive == null) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text('Token tidak ditemukan. Silakan login kembali.')),
    //     );
    //     return;
    //   }

    //   JournalingService journalingService = JournalingService();
      // Map<String, dynamic> moodData = await journalingService.fetchMoodDetails(tokenActive, idUserActive);
      
    //   setState(() {
    //     _moodDetails = moodData;
    //   });

    //   // Simpan data mood ke SharedPreferences jika diperlukan
    //   prefs.setString('moodData', jsonEncode(_moodDetails));

    // } catch (e) {
    //   print('Error loading mood data: $e');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        title: Text(
          "Detail Mood",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xffffffff),
        elevation: 10, // Menambahkan shadow lebih tebal di bawah AppBar
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        // Membuat halaman menjadi scrollable
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  // Menampilkan tanggal dengan background dan border radius
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Color(0xffCAE4FC), // Menambahkan background color
                      borderRadius: BorderRadius.circular(
                        12,
                      ), // Menambahkan border radius
                    ),
                    child: Text(
                      DateFormat('dd MMM yyyy').format(widget.date), // Format tanggal
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black, // Warna teks
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Menampilkan emote
                  if (widget.selectedEmote.isNotEmpty)
                    Image.asset(
                      widget.selectedEmote, // Menampilkan emote
                      height: 100,
                      width: 100,
                    ),
                  SizedBox(height: 10),
                  // Menampilkan status mood
                  Text(
                    "Status Mood: $widget.selectedMood", // Menampilkan status mood
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text(
              "User Mood:",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black, // Warna teks
              ),
            ),
            SizedBox(height: 5),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: (widget.moodDetails['userMood'] as List).map<Widget>((mood) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xff74B6F2), width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: Text(mood, style: GoogleFonts.poppins()),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text(
              "Baby Mood:",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black, // Warna teks
              ),
            ),
            SizedBox(height: 5),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: (widget.moodDetails['babyMood'] as List).map<Widget>((mood) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xffFFBCD9), width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: Text(mood, style: GoogleFonts.poppins()),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text(
              "Description:",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black, // Warna teks
              ),
            ),
            SizedBox(height: 5),
            Text(
              widget.moodDetails['description'] ?? "-",
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              "Photos:",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black, // Warna teks
              ),
            ),
            if (widget.moodDetails['image'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: GestureDetector(
                  onTap: () {
                    // Menampilkan gambar dalam pop-up
                    showDialog(
                      context: context,
                      barrierDismissible:
                          true, // Menutup dialog saat mengetuk di luar gambar
                      builder: (BuildContext context) {
                        return Dialog(
                          backgroundColor: Colors.transparent,
                          child: GestureDetector(
                            onTap: () {
                              // Menutup dialog jika mengetuk di luar gambar
                              Navigator.pop(context);
                            },
                            child: Material(
                              color: Colors.transparent,
                              child: InteractiveViewer(
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.file(
                                      File(widget.moodDetails['image']),
                                      fit: BoxFit.contain, // Original size
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      10,
                    ), // Menambahkan border radius
                    child: Image.file(
                      File(widget.moodDetails['image']),
                      width: 180, // Mengatur lebar gambar
                      height: 180, // Mengatur tinggi gambar
                      fit: BoxFit.cover, // Menjaga rasio gambar tetap konsisten
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
