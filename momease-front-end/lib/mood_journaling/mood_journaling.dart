import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:front_end/navbar/custom_navbar.dart';
import 'package:front_end/services/journaling_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import '../notification/notification.dart';
import 'history_mood_journaling.dart';

class MoodTrackerScreen extends StatefulWidget {
  @override
  _MoodTrackerScreenState createState() => _MoodTrackerScreenState();
}

Map<String, int> moodToNumber = {
  "Angry": 1,
  "Sad": 2,
  "Neutral": 3,
  "Happy": 4,
  "Excited": 5,
};

class _MoodTrackerScreenState extends State<MoodTrackerScreen> {
  Map<DateTime, Map<int, dynamic>> _moodData = {};
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _loadMoodData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadMoodData();
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

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? idUserActive = prefs.getInt('idUser');
      String? tokenActive = prefs.getString('token');
      // Validasi idUserActive
      if (idUserActive == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('ID User tidak ditemukan. Silakan login kembali.')),
        );
        return;
      }

      if (tokenActive == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Token tidak ditemukan. Silakan login kembali.')),
        );
        return;
      }

      JournalingService journalingService = JournalingService();
      Map<DateTime, Map<int, dynamic>> moodData =
          await journalingService.fetchMoodSummary(tokenActive, idUserActive);

      setState(() {
        _moodData = moodData;
      });

      // Simpan data mood ke SharedPreferences jika diperlukan
      prefs.setString('moodData', jsonEncode(_moodData));
    } catch (e) {
      print('Error loading mood data: $e');
    }
  }

  Future<void> _saveMoodData() async {
    final prefs = await SharedPreferences.getInstance();

    // Encode _moodData menjadi JSON dengan key DateTime yang diubah ke string
    prefs.setString(
      'moodData',
      jsonEncode(
        _moodData.map(
          (key, value) =>
              MapEntry(key.toIso8601String(), Map<int, dynamic>.from(value)),
        ),
      ),
    );
  }

  Future<void> _showFillMoodPage(DateTime date) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FillMoodPage(selectedDate: date, moodData: _moodData[date]),
      ),
    );

    if (result != null) {
      setState(() {
        _moodData[date] = result;
      });
      // _saveMoodData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendar", style: TextStyle(fontSize: 20)),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.history), // Ikon kotak berbaris
          onPressed: () {
            // Arahkan ke halaman History
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HistoryPage()),
            );
          },
        ),
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
        child: Column(
          children: [
            TableCalendar(
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              calendarFormat: CalendarFormat.month,
              availableCalendarFormats: const {CalendarFormat.month: 'Month'},
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                final today = DateTime.now();

                if (!_moodData.containsKey(selectedDay)) {
                  if (selectedDay.isBefore(today) ||
                      isSameDay(selectedDay, today)) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                    _showFillMoodPage(selectedDay);
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 5,
                            sigmaY: 5,
                          ),
                          child: AlertDialog(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            contentPadding: EdgeInsets.all(16),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Invalid Date",
                                  style: TextStyle(
                                    fontSize: 27,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "You can only fill the mood for today!",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF808080)),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 50),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF6495ED),
                                    foregroundColor: Colors.white,
                                    minimumSize: Size(double.infinity, 45),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    "Okay!",
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
                  }
                } else {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 5,
                            sigmaY: 5,
                          ),
                          child: AlertDialog(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            contentPadding: EdgeInsets.all(16),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Hmm, you've filled your mood today!",
                                  style: TextStyle(
                                    fontSize: 27,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Check your mood history to see your past mood.",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF808080)),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 50),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF6495ED),
                                    foregroundColor: Colors.white,
                                    minimumSize: Size(double.infinity, 45),
                                  ),
                                  onPressed: () {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HistoryPage()),
                                      (Route<dynamic> route) => false,
                                    );
                                  },
                                  child: Text(
                                    "I want check!",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Color(0xff808080),
                                    minimumSize: Size(double.infinity, 45),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    "Maybe later...",
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
                      });
                }
              },
              headerStyle: HeaderStyle(
                titleCentered:
                    true, // Menempatkan nama bulan dan tahun di tengah
                formatButtonVisible: false, // Menyembunyikan tombol format
                titleTextStyle: TextStyle(
                  fontSize: 18, // Ukuran font
                  fontWeight: FontWeight.bold, // Membuat font tebal
                ),
              ),
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, day, _) {
                  // Debug: Cetak semua key dari _moodData dan nilai day
                  debugPrint("Keys in _moodData: ${_moodData.keys}");
                  debugPrint("Current day: $day");

                  // if (_moodData.containsKey(day)) {
                  //   final overallMood = _moodData[day]?['overallMood'];
                  //   int moodNumber = moodToNumber[overallMood] ?? 0;
                  //   if (overallMood != null) {
                  //     final moodImage =
                  //         'assets/emote/${moodNumber}_selected.png';
                  // Cek apakah _moodData memiliki key yang sesuai dengan tanggal (hanya tanggal, tanpa waktu)
                  if (_moodData.keys.any((key) => isSameDay(key, day))) {
                    final matchingKey =
                        _moodData.keys.firstWhere((key) => isSameDay(key, day));
                    final moodValue = _moodData[matchingKey]?.values.first;
                    debugPrint("Mood found for $day: $moodValue");

                    if (moodValue != null) {
                      int moodNumber =
                          moodValue; // Pastikan nilai mood adalah angka
                      final moodImage =
                          'assets/emote/${moodNumber}_selected.png';
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Opacity(
                            opacity: 1, // Semi-transparent mood image
                            child:
                                Image.asset(moodImage, height: 55, width: 30),
                          ),
                        ],
                      );
                    }
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomFloatingNavBar(
        selectedIndex: 2,
        onItemTapped: (index) {
          // Handle navigation based on the selected index
        },
      ),
    );
  }
}

class FillMoodPage extends StatefulWidget {
  final DateTime selectedDate;
  final Map<int, dynamic>? moodData;

  FillMoodPage({required this.selectedDate, this.moodData});

  @override
  _FillMoodPageState createState() => _FillMoodPageState();
}

class _FillMoodPageState extends State<FillMoodPage> {
  List<String> selectedUserMood = [];
  List<String> selectedBabyMood = [];
  String? selectedOverallMood;
  TextEditingController _dayDescriptionController = TextEditingController();
  bool moodSaved = false;
  bool _isLoading = false;
  final JournalingService _apiService = JournalingService();
  String _randomQuestion = "Share about your day..."; // Initial message
  XFile? _image;

  final List<String> _questions = [
    "Tell us about what made you feel happy today.",
    "What did you do today that brought you peace and relaxation?",
    "How did you handle the stress today? Feel free to share.",
    "Did something unexpected happen today? We’d love to hear about it.",
    "How would you describe your overall mood today? Let it all out.",
    "What made you feel supported today? Share what helped.",
    "What are you most grateful for today? Speak your mind.",
    "What helped you stay calm today? Tell us all about it.",
    "How did your baby do today? Feel free to share your thoughts.",
    "Was there a moment today when you felt overwhelmed? Let’s talk about it.",
  ];

  // Method to generate a random question
  void _generateRandomQuestion() {
    setState(() {
      _randomQuestion = (_questions..shuffle()).first;
    });
  }

  List<XFile>? _images =
      []; // Variabel untuk menampung gambar-gambar yang dipilih

  Future<void> _pickImages() async {
    final picker = ImagePicker();

    // Tampilkan dialog untuk memilih antara galeri atau kamera
    final selectedSource = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              "Pick Images",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 27,
              ),
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.camera),
                  title: Text("Camera"),
                  onTap: () {
                    Navigator.pop(context, ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_album),
                  title: Text("Gallery"),
                  onTap: () {
                    Navigator.pop(context, ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selectedSource != null) {
      final pickedFile = selectedSource == ImageSource.gallery
          ? await picker.pickImage(source: ImageSource.gallery)
          : await picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        setState(() {
          _image = pickedFile; // Perbarui _image dengan gambar yang dipilih
        });
      }
    }
  }

  Widget _buildMoodContainer(
    String title,
    List<String> moods,
    List<String> selectedMoods,
    Function(String) onMoodSelected, {
    bool showImages = false,
    bool isBabyMood = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: moods.map((mood) {
            bool isSelected = selectedMoods.contains(mood);

            // Determine the image name based on the selected state
            int moodNumber = moodToNumber[mood] ??
                0; // Default ke 0 jika mood tidak ada dalam map
            String imageName = isSelected
                ? 'assets/emote/${moodNumber}_selected.png'
                : 'assets/emote/${moodNumber}.png';

            // Set the background color based on mood category
            Color moodBackgroundColor;
            if (isBabyMood) {
              moodBackgroundColor =
                  isSelected ? Color(0xFFFFBCD9) : Colors.grey.shade300;
            } else {
              moodBackgroundColor =
                  isSelected ? Color(0xFF74B6F2) : Colors.grey.shade300;
            }

            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedMoods.remove(mood);
                  } else {
                    selectedMoods.add(mood);
                  }
                });
                onMoodSelected(mood);
              },
              child: showImages
                  ? Column(
                      children: [
                        Image.asset(imageName, height: 40, width: 40),
                        Text(
                          mood,
                          style: TextStyle(
                            color: isSelected ? Colors.black : Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  : Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      decoration: BoxDecoration(
                        color: moodBackgroundColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        mood,
                        style: TextStyle(
                          color: isSelected
                              ? const Color.fromARGB(255, 0, 0, 0)
                              : Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Future<void> _handleSaveMood(int mood) async {
    // if (_passwordController.text != _confirmPasswordController.text) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Passwords do not match')),
    //   );
    //   return;
    // }

    setState(() {
      _isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? idUserActive = prefs.getInt('idUser');
    String? tokenActive = prefs.getString('token');
    // Validasi idUserActive
    if (idUserActive == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('ID User tidak ditemukan. Silakan login kembali.')),
      );
      return;
    }

    if (tokenActive == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Token tidak ditemukan. Silakan login kembali.')),
      );
      return;
    }

    final moodData = {
      'idUser': idUserActive, // Ganti dengan ID user yang sesuai
      'mood': mood,
      'perasaan': selectedUserMood,
      'kondisiBayi': selectedBabyMood,
      'textJurnal': _dayDescriptionController.text.isNotEmpty
          ? _dayDescriptionController.text
          : 'No journal entry provided',
      // 'imagePath': _image?.path,
      'tglInput': widget.selectedDate.toLocal().toString(),
    };

    // Convert to JSON string
    final jsonString = jsonEncode(moodData);

    // Print to console
    print('JSON Format: $jsonString');

    final result = await _apiService.saveMood(moodData, tokenActive);

    setState(() {
      _isLoading = false;
    });

    if (result['success']) {
      // Registrasi berhasil
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Journal saved'),
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.pop(context);
    } else {
      // Registrasi gagal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Save failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, int> moodToNumber = {
      "Angry": 1,
      "Sad": 2,
      "Neutral": 3,
      "Happy": 4,
      "Excited": 5,
    };
    return Scaffold(
      appBar: AppBar(
        title: Text('Fill Mood'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.selectedDate.toLocal().toString().split(' ')[0],
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 20),
              _buildMoodContainer(
                "How's your mood today?",
                ["Angry", "Sad", "Neutral", "Happy", "Excited"],
                selectedOverallMood != null ? [selectedOverallMood!] : [],
                (mood) {
                  setState(() {
                    selectedOverallMood = mood;
                  });
                },
                showImages: true,
              ),
              SizedBox(height: 35),
              _buildMoodContainer(
                "How are you doing today?",
                [
                  "Calm",
                  "Relaxed",
                  "Happy",
                  "Tired",
                  "Stressed",
                  "Anxious",
                  "Grateful",
                  "Hopeful",
                  "Bored",
                  "Supported",
                  "Sad",
                  "Lonely",
                ],
                selectedUserMood,
                (mood) => setState(() {}),
              ),
              SizedBox(height: 40),
              _buildMoodContainer(
                "How's your baby doing today?",
                [
                  "Calm",
                  "Hungry",
                  "Happy",
                  "Sleepy",
                  "Active",
                  "Fussy",
                  "Gassy",
                  "Crying",
                  "Sick",
                ],
                selectedBabyMood,
                (mood) => setState(() {}),
                isBabyMood: true,
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _randomQuestion,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: _generateRandomQuestion,
                  ),
                ],
              ),
              SizedBox(height: 16),
              TextField(
                controller: _dayDescriptionController,
                decoration: InputDecoration(
                  labelText: "Day Description",
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              SizedBox(height: 40),
              GestureDetector(
                onTap:
                    _pickImages, // Ketika kolom ini diketuk, akan memunculkan pilihan galeri atau kamera
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 16.0), // Memberikan padding vertikal
                  decoration: BoxDecoration(
                    color: Colors.white, // Warna latar belakang biru
                    borderRadius:
                        BorderRadius.circular(12.0), // Membuat sudut membulat
                    border: Border.all(color: Color(0xff1B3F74), width: 2),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt, // Ikon kamera
                        color: Color(0xff1B3F74),
                        size: 50, // Ukuran ikon
                      ),
                      SizedBox(
                          height: 8), // Memberikan jarak antara ikon dan teks
                      Text(
                        "Attach your image here", // Teks di bawah ikon
                        style: TextStyle(
                          color: Color(0xff1B3F74),
                          fontSize: 16, // Ukuran font
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              if (_image != null) ...[
                SizedBox(height: 8),
                Image.file(
                  File(_image!.path),
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ],
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  // Navigator.pop(context, {
                  //   'userMood': selectedUserMood,
                  //   'babyMood': selectedBabyMood,
                  //   'overallMood': selectedOverallMood,
                  //   'description': _dayDescriptionController.text,
                  //   'image': _image?.path,
                  // });
                  _handleSaveMood(moodToNumber[selectedOverallMood] ?? 0);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6495ED),
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 45)),
                child: Text(
                  'Save',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
