import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';

import 'history_mood_journaling.dart';
import 'notification.dart';

void main() {
  runApp(MoodJournaling());
}

class MoodJournaling extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF74B6F2), // Blue color updated
        ),
      ),
      home: MoodTrackerScreen(),
    );
  }
}

class MoodTrackerScreen extends StatefulWidget {
  @override
  _MoodTrackerScreenState createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> {
  Map<DateTime, Map<String, dynamic>> _moodData = {};
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _loadMoodData();
  }

  Future<void> _loadMoodData() async {
    final prefs = await SharedPreferences.getInstance();
    final data =
        prefs.getString('moodData') ?? '{}'; // Ambil data yang ada, jika ada

    setState(() {
      // Decode JSON dan transformasikan menjadi Map<DateTime, Map<String, dynamic>>
      _moodData = (jsonDecode(data) as Map<String, dynamic>).map<
        DateTime,
        Map<String, dynamic>
      >((key, value) {
        // Mengkonversi string tanggal menjadi DateTime dan memastikan value menjadi Map<String, dynamic>
        return MapEntry(DateTime.parse(key), Map<String, dynamic>.from(value));
      });
    });
  }

  Future<void> _saveMoodData() async {
    final prefs = await SharedPreferences.getInstance();

    // Encode _moodData menjadi JSON dengan key DateTime yang diubah ke string
    prefs.setString(
      'moodData',
      jsonEncode(
        _moodData.map(
          (key, value) =>
              MapEntry(key.toIso8601String(), Map<String, dynamic>.from(value)),
        ),
      ),
    );
  }

  Future<void> _showFillMoodPage(DateTime date) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                FillMoodPage(selectedDate: date, moodData: _moodData[date]),
      ),
    );

    if (result != null) {
      setState(() {
        _moodData[date] = result;
      });
      _saveMoodData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mood Journaling Calendar", style: TextStyle(fontSize: 18)),
        centerTitle: true,
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
            icon: Icon(Icons.notifications), // Ikon notifikasi
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

      body: Column(
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
                if (isSameDay(selectedDay, today)) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  _showFillMoodPage(selectedDay);
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Invalid Date"),
                        content: Text("You can only fill the mood for today!"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("OK"),
                          ),
                        ],
                      );
                    },
                  );
                }
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Mood Already Saved"),
                      content: Text(
                        "Mood for this date is already saved and cannot be edited.",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("OK"),
                        ),
                      ],
                    );
                  },
                );
              }
            },

            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, _) {
                if (_moodData.containsKey(day)) {
                  final overallMood = _moodData[day]?['overallMood'];
                  if (overallMood != null) {
                    final moodImage =
                        'assets/emote/${overallMood.toLowerCase()}_selected.png';
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Opacity(
                          opacity: 1, // Semi-transparent mood image
                          child: Image.asset(moodImage, height: 55, width: 30),
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
    );
  }
}

class FillMoodPage extends StatefulWidget {
  final DateTime selectedDate;
  final Map<String, dynamic>? moodData;

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
  String _randomQuestion =
      "Click the icon on the right side to make it easier to express your feelings."; // Initial message
  XFile? _image;

  final List<String> _questions = [
    "What made you feel happy today?",
    "What did you do to relax today?",
    "How did you cope with stress today?",
    "Did anything unexpected happen today?",
    "How would you describe your mood overall?",
    "What made you feel supported today?",
    "What are you grateful for today?",
    "What helped you feel calm today?",
    "How did your baby do today?",
    "Was there any moment you felt overwhelmed?",
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
        return AlertDialog(
          title: Text("Pick Images"),
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
        );
      },
    );

    if (selectedSource != null) {
      if (selectedSource == ImageSource.gallery) {
        // Pilih banyak gambar dari galeri
        final pickedFiles = await picker.pickMultiImage();

        if (pickedFiles != null) {
          setState(() {
            _images = pickedFiles; // Menyimpan daftar gambar yang dipilih
          });
        }
      } else {
        // Jika memilih dari kamera, hanya bisa mengambil satu foto
        final pickedFile = await picker.pickImage(source: selectedSource);
        if (pickedFile != null) {
          setState(() {
            _images = [pickedFile]; // Menyimpan satu gambar dari kamera
          });
        }
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
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              moods.map((mood) {
                bool isSelected = selectedMoods.contains(mood);

                // Determine the image name based on the selected state
                String imageName =
                    isSelected
                        ? 'assets/emote/${mood.toLowerCase()}_selected.png'
                        : 'assets/emote/${mood.toLowerCase()}.png';

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
                  child:
                      showImages
                          ? Column(
                            children: [
                              Image.asset(imageName, height: 40, width: 40),
                              Text(
                                mood,
                                style: TextStyle(
                                  color:
                                      isSelected
                                          ? Colors.black
                                          : Colors.black54,
                                  fontWeight: FontWeight.bold,
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
                                color:
                                    isSelected
                                        ? const Color.fromARGB(255, 0, 0, 0)
                                        : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                );
              }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fill Mood'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.selectedDate.toLocal().toString().split(' ')[0],
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              _buildMoodContainer(
                "Choose your overall mood for the day",
                ["Angry", "Sad", "Neutral", "Happy", "Excited"],
                selectedOverallMood != null ? [selectedOverallMood!] : [],
                (mood) {
                  setState(() {
                    selectedOverallMood = mood;
                  });
                },
                showImages: true,
              ),
              SizedBox(height: 16),
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
              SizedBox(height: 16),
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
              SizedBox(height: 16),
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
              SizedBox(height: 16),
              GestureDetector(
                onTap: _pickImages,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        "Attach Image",
                        style: TextStyle(color: Colors.white),
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
                onPressed: () {
                  Navigator.pop(context, {
                    'userMood': selectedUserMood,
                    'babyMood': selectedBabyMood,
                    'overallMood': selectedOverallMood,
                    'description': _dayDescriptionController.text,
                    'image': _image?.path,
                  });
                },
                child: Text('Save Mood'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
