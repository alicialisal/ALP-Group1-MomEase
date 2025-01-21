import 'package:flutter/material.dart';
import 'package:front_end/kegiatan_relaksasi/search_page.dart';
import 'dart:async';
import 'dart:ui';

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
    return WillPopScope(
      onWillPop: () async {
        // Menampilkan dialog saat tombol back device ditekan
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Blur background
              child: AlertDialog(
                title: Text(
                  'Are you sure want to quit this activity?',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 27),
                ),
                content: Text(
                  'Are you willing to go back?',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF808080),
                  ),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context, false); // Tidak keluar
                          },
                          child: Text(
                            'No, I don\'t',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context, true); // Keluar
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(10),
                          ),
                          child: Text(
                            'Yes, I do',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
        return shouldPop ?? false; // Keluar hanya jika 'Yes, I do' dipilih
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.activity['title'],
            style: TextStyle(color: Color(0xFFFFFFFF)),
          ),
          backgroundColor: widget.activity['categoryColor'],
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 5,
                      sigmaY: 5,
                    ), // Blur background
                    child: AlertDialog(
                      title: Text(
                        'Are you sure want to quit this activity?',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 27,
                        ),
                      ),
                      content: Text(
                        'Are you willing to go back?',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF808080),
                        ),
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.end, // Posisi tombol di kanan
                          children: [
                            Expanded(
                              flex: 1, // Proporsi lebar tombol
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close dialog
                                },
                                child: Text(
                                  'No, I don\'t',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            SizedBox(width: 8), // Jarak antar tombol
                            Expanded(
                              flex: 1, // Proporsi lebar tombol
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close dialog
                                  Navigator.pop(
                                    context,
                                  ); // Navigate to previous page
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.all(10),
                                ),
                                child: Text(
                                  'Yes, I do',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: Text(
                      isPaused ? 'Resume' : 'Pause',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible:
                            true, // Background dapat di-klik untuk menutup dialog
                        builder: (BuildContext context) {
                          return BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 5,
                              sigmaY: 5,
                            ), // Blur background

                            child: AlertDialog(
                              title: Text(
                                'Are you sure wanna quit?',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 27,
                                ),
                              ),
                              content: Text(
                                'We\'ll take you back to list activities',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF808080),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Tutup dialog
                                  },
                                  child: Text(
                                    'No, I don\'t',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Tutup dialog
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RelaxationApp(),
                                      ),
                                      (route) =>
                                          false, // Menghapus semua rute sebelumnya
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: Text(
                                    'Yes, I want',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
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
      ),
    );
  }
}
