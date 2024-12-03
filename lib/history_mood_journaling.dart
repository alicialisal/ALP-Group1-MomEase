import 'package:flutter/material.dart';
import 'package:front_end/mood_journaling.dart';
import 'package:front_end/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';

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
    _loadHistoryData();
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

  String _getEmoteImage(String overallMood) {
    switch (overallMood.toLowerCase()) {
      case 'happy':
        return 'assets/emote/happy_selected.png';
      case 'sad':
        return 'assets/emote/sad_selected.png';
      case 'neutral':
        return 'assets/emote/neutral_selected.png';
      case 'angry':
        return 'assets/emote/angry_selected.png';
      case 'excited':
        return 'assets/emote/excited_selected.png';
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
          'Mood History',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold, // Ubah judul jadi bold
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xffffffff),
        leading: IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MoodJournaling()),
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
            child:
                filteredData.isEmpty
                    ? Center(child: Text("No data available"))
                    : ListView.builder(
                      itemCount: filteredData.length,
                      itemBuilder: (context, index) {
                        DateTime date = filteredData.keys.toList()[index];
                        Map<String, dynamic> moodDetails = filteredData[date]!;

                        return Container(
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
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  date.toLocal().toString().split(' ')[0],
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),

                                SizedBox(height: 5),

                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 14),
                                      child: Image.asset(
                                        _getEmoteImage(
                                          moodDetails['overallMood'],
                                        ),
                                        height: 65,
                                        width: 65,
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
                                            children:
                                                (moodDetails['userMood'] as List).map<
                                                  Widget
                                                >((mood) {
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
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 5,
                                                        ),
                                                    child: Text(
                                                      mood,
                                                      style:
                                                          GoogleFonts.poppins(),
                                                    ),
                                                  );
                                                }).toList(),
                                          ),

                                          SizedBox(height: 8),

                                          // Mood Baby
                                          Wrap(
                                            spacing: 8.0,
                                            runSpacing: 8.0,
                                            children:
                                                (moodDetails['babyMood'] as List).map<
                                                  Widget
                                                >((mood) {
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
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 5,
                                                        ),
                                                    child: Text(
                                                      mood,
                                                      style:
                                                          GoogleFonts.poppins(),
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
                                  "${moodDetails['description']}",
                                  style: GoogleFonts.poppins(),
                                ),
                                if (moodDetails['image'] != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Image.file(
                                      File(moodDetails['image']),
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                              ],
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
