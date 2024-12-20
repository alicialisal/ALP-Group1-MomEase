import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MoodGraphPage extends StatelessWidget {
  final List<String> moods = ['Angry', 'Sad', 'Neutral', 'Happy', 'Excited'];
  final List<DateTime> dates = List.generate(
    30,
    (index) => DateTime(2024, 12, index + 1),
  );
  final List<int> moodValues = [
    0,
    2,
    3,
    1,
    4,
    2,
    0,
    4,
    3,
    2,
    1,
    0,
    4,
    3,
    2,
    1,
    0,
    4,
    3,
    2,
    1,
    0,
    4,
    3,
    2,
    1,
    0,
    4,
    3,
    2,
  ]; // Mood per tanggal (contoh)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mood Graph",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 10,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Mood Journal - December 2024",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1, // Jarak antar judul
                        getTitlesWidget: (value, meta) {
                          if (value >= 0 && value < moods.length) {
                            return Text(
                              moods[value.toInt()],
                              style: GoogleFonts.poppins(fontSize: 12),
                              textAlign: TextAlign.left,
                            );
                          }
                          return Container(); // Jika nilai di luar rentang, kosongkan
                        },
                      ),
                    ),

                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 5, // Menampilkan tanggal setiap 5 hari
                        getTitlesWidget: (value, meta) {
                          int dayIndex = value.toInt();
                          if (dayIndex >= 0 &&
                              dayIndex < dates.length &&
                              dayIndex % 5 == 0) {
                            return Text(
                              '${dates[dayIndex].day}',
                              style: GoogleFonts.poppins(fontSize: 10),
                              textAlign: TextAlign.center,
                            );
                          }
                          return Container();
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        dates.length,
                        (index) => FlSpot(
                          index.toDouble(),
                          moodValues[index].toDouble(),
                        ),
                      ),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                  minY: 0,
                  maxY: (moods.length - 1).toDouble(),
                  minX: 0,
                  maxX: (dates.length - 1).toDouble(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
