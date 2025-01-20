import 'package:flutter/material.dart';
import 'dart:async';

class RelaxationTimerPage extends StatefulWidget {
  final Map<String, dynamic> activity;

  const RelaxationTimerPage({Key? key, required this.activity})
      : super(key: key);

  @override
  _RelaxationTimerPageState createState() => _RelaxationTimerPageState();
}

class _RelaxationTimerPageState extends State<RelaxationTimerPage> {
  late int totalSeconds;
  late int remainingSeconds;
  Timer? _timer;
  bool isPaused = false;

  @override
  void initState() {
    super.initState();
    totalSeconds = _parseDurationToSeconds(widget.activity['duration']);
    remainingSeconds = totalSeconds;
    _startTimer();
  }

  int _parseDurationToSeconds(String duration) {
    final parts = duration.split(' ');
    final minutes = int.parse(parts[0]);
    return minutes * 60;
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isPaused && remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else if (remainingSeconds <= 0) {
        _timer?.cancel();
      }
    });
  }

  void _pauseTimer() {
    setState(() {
      isPaused = true;
    });
  }

  void _resumeTimer() {
    setState(() {
      isPaused = false;
    });
  }

  void _exitActivity() {
    _timer?.cancel();
    Navigator.pop(context);
  }

  String _formatTime(int seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.activity['title'],
          style: TextStyle(color: Color(0xFFFFFFFF)),
        ),
        backgroundColor: widget.activity['categoryColor'],
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Remaining Time',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  _formatTime(remainingSeconds),
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Text(
              widget.activity['description'],
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: double.infinity),
                ElevatedButton(
                  onPressed: isPaused ? _resumeTimer : _pauseTimer,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: Text(
                    isPaused ? 'Resume' : 'Pause',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _exitActivity,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text(
                    'Exit Activity',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
