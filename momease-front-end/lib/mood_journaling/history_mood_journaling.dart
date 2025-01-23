import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front_end/mood_journaling/mood_journaling.dart';
import 'package:front_end/notification/notification.dart';
import 'package:front_end/services/journaling_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'detail_mood_journaling.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  Map<DateTime, Map<String, dynamic>> _historyData = {};
  DateTime _selectedMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadMoodHistory();
  }

  Future<void> _loadMoodHistory() async {
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

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? idUserActive = prefs.getInt('idUser');
      String? tokenActive = prefs.getString('token');
      // Validasi idUserActive
      if (idUserActive == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ID User tidak ditemukan. Silakan login kembali.')),
        );
        return;
      }

      if (tokenActive == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Token tidak ditemukan. Silakan login kembali.')),
        );
        return;
      }

      JournalingService journalingService = JournalingService();
      Map<DateTime, Map<String, dynamic>> moodData = await journalingService.fetchMoodDetails(tokenActive, idUserActive);
      
      setState(() {
        _historyData = moodData;
      });

      // Simpan data mood ke SharedPreferences jika diperlukan
      prefs.setString('moodData', jsonEncode(_historyData));

    } catch (e) {
      print('Error loading mood data: $e');
    }
  }

  Future<void> _loadHistoryData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('moodData') ?? '{}';

    setState(() {
      _historyData = (jsonDecode(data) as Map<String, dynamic>)
          .map<DateTime, Map<String, dynamic>>(
        (key, value) =>
            MapEntry(DateTime.parse(key), Map<String, dynamic>.from(value)),
      );
    });
  }

  Map<DateTime, Map<String, dynamic>> _filterHistoryByMonth(
    DateTime selectedMonth,
  ) {
    return Map.fromEntries(
      _historyData.entries.where(
        (entry) =>
            entry.key.month == selectedMonth.month &&
            entry.key.year == selectedMonth.year,
      ),
    );
  }

  String _getEmoteImage(int overallMood) {
    switch (overallMood) {
      case 4:
        return 'assets/emote/4_selected.png';
      case 2:
        return 'assets/emote/2_selected.png';
      case 3:
        return 'assets/emote/3_selected.png';
      case 1:
        return 'assets/emote/1_selected.png';
      case 5:
        return 'assets/emote/5_selected.png';
      default:
        return 'assets/emote/unknown.png'; // Gambar default jika tidak ditemukan
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<DateTime, Map<String, dynamic>> filteredData = _filterHistoryByMonth(
      _selectedMonth,
    );
    String formattedMonth = DateFormat('MMMM yyyy').format(_selectedMonth);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'History',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold, // Ubah judul jadi bold
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xffffffff),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MoodTrackerScreen()),
            );
          },
        ),
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
      backgroundColor: Colors.white, // Background halaman jadi putih
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_left),
                  onPressed: () {
                    setState(() {
                      _selectedMonth = DateTime(
                        _selectedMonth.year,
                        _selectedMonth.month - 1,
                        1,
                      );
                    });
                  },
                ),
                Text(
                  formattedMonth,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_right),
                  onPressed: () {
                    setState(() {
                      _selectedMonth = DateTime(
                        _selectedMonth.year,
                        _selectedMonth.month + 1,
                        1,
                      );
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredData.isEmpty
                ? Center(child: Text("You haven't filled any mood yet"))
                : ListView.builder(
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      DateTime date = filteredData.keys.toList()[index];
                      Map<String, dynamic> moodDetails = filteredData[date]!;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(
                                date: date,
                                moodDetails: moodDetails,
                                selectedEmote: _getEmoteImage(
                                  moodDetails['overallMood'],
                                ), // Mengirim emote yang dipilih
                                selectedMood: moodDetails[
                                    'overallMood'], // Mengirim status mood
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Color(0xff1B3F74),
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        right: 5.5,
                                      ), // Jarak pada sisi kanan
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center, // Mengatur posisi di tengah
                                        crossAxisAlignment: CrossAxisAlignment
                                            .center, // Mengatur posisi di tengah horizontal
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.blue
                                                  .shade100, // Warna latar belakang
                                              borderRadius:
                                                  BorderRadius.circular(
                                                8.0,
                                              ), // Radius untuk border
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12.0,
                                              vertical: 8.0,
                                            ), // Padding dalam container
                                            child: Text(
                                              DateFormat('dd MMM').format(
                                                date,
                                              ), // Format tanggal menjadi 12 Dec
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ), // Jarak antara tanggal dan emote
                                          Image.asset(
                                            _getEmoteImage(
                                              moodDetails['mood'],
                                            ),
                                            height: 65,
                                            width: 65,
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Kolom Mood Details (User & Baby Mood)
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Mood User
                                          Wrap(
                                            spacing: 8.0,
                                            runSpacing: 8.0,
                                            children: (moodDetails['perasaan']
                                                    as List)
                                                .map<Widget>((mood) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Color(
                                                      0xff74B6F2,
                                                    ),
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    20,
                                                  ),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 5,
                                                ),
                                                child: Text(
                                                  mood,
                                                  style: GoogleFonts.poppins(),
                                                ),
                                              );
                                            }).toList(),
                                          ),

                                          SizedBox(height: 8),

                                          // Mood Baby
                                          Wrap(
                                            spacing: 8.0,
                                            runSpacing: 8.0,
                                            children: (moodDetails['kondisiBayi']
                                                    as List)
                                                .map<Widget>((mood) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Color(
                                                      0xffFFBCD9,
                                                    ),
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    20,
                                                  ),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 5,
                                                ),
                                                child: Text(
                                                  mood,
                                                  style: GoogleFonts.poppins(),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Click for more details",
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontStyle: FontStyle.italic,
                                    color: Color(0xff808080),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
