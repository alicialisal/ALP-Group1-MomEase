import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class DetailPage extends StatelessWidget {
  final DateTime date;
  final Map<String, dynamic> moodDetails;

  DetailPage({required this.date, required this.moodDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Mood", style: GoogleFonts.poppins()),
        backgroundColor: Color(0xff1B3F74),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Date: ${DateFormat('dd MMM yyyy').format(date)}",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 10),
            Text("User Mood:", style: GoogleFonts.poppins(fontSize: 16)),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children:
                  (moodDetails['userMood'] as List).map<Widget>((mood) {
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
            SizedBox(height: 10),
            Text("Baby Mood:", style: GoogleFonts.poppins(fontSize: 16)),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children:
                  (moodDetails['babyMood'] as List).map<Widget>((mood) {
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
            SizedBox(height: 10),
            Text("Description:", style: GoogleFonts.poppins(fontSize: 16)),
            Text(
              moodDetails['description'] ?? "-",
              style: GoogleFonts.poppins(),
            ),
            if (moodDetails['image'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Image.file(
                  File(moodDetails['image']),
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
