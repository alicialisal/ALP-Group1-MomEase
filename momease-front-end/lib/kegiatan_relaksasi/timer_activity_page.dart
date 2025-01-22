import 'package:flutter/material.dart';
import 'dart:async';

class TimerActivityPage extends StatefulWidget {
  final String duration;

  TimerActivityPage({required this.duration});

  @override
  _TimerActivityPageState createState() => _TimerActivityPageState();
}

class _TimerActivityPageState extends State<TimerActivityPage> {
  late int _remainingTime;
  late Timer _timer;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    // Parse durasi dari string menjadi detik
    _remainingTime = _parseDuration(widget.duration);
    _startTimer();
  }

  // Fungsi untuk mengkonversi format mm:ss ke dalam detik
  int _parseDuration(String duration) {
    final parts = duration.split(':');
    if (parts.length == 2) {
      try {
        int minutes = int.parse(parts[0]);
        int seconds = int.parse(parts[1]);
        return minutes * 60 + seconds; // Mengkonversi menjadi detik
      } catch (e) {
        print('Error parsing duration: $e');
        return 0;
      }
    } else {
      print('Invalid duration format');
      return 0;
    }
  }

  // Fungsi untuk memulai timer yang akan menghitung mundur setiap detik
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0 && !_isPaused) {
        setState(() {
          _remainingTime--;
        });
      } else if (_remainingTime == 0) {
        _timer.cancel(); // Menghentikan timer ketika waktu mencapai 0
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Time's Up!"),
              content: Text("Your time has ended."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    });
  }

  // Fungsi untuk memformat waktu dalam format mm:ss
  String _formatTime(int time) {
    int minutes = time ~/ 60;
    int seconds = time % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // Fungsi untuk menjeda atau melanjutkan timer
  void _pauseTimer() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  // Fungsi untuk keluar dari aktivitas dan kembali ke halaman sebelumnya
  void _exitActivity() {
    Navigator.pop(context); // Kembali ke halaman sebelumnya
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Timer'),
        centerTitle: true,
        backgroundColor: Color(0xff6495ED),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Menampilkan timer
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                _formatTime(
                  _remainingTime,
                ), // Menampilkan waktu dalam format mm:ss
                style: TextStyle(
                  fontSize: 48.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20.0),

            // Tombol Pause/Resume
            ElevatedButton(
              onPressed: _pauseTimer,
              child: Text(
                _isPaused ? 'Resume' : 'Pause',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
            SizedBox(height: 20.0),

            // Tombol Exit
            ElevatedButton(
              onPressed: _exitActivity,
              child: Text(
                'Exit Activity',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
