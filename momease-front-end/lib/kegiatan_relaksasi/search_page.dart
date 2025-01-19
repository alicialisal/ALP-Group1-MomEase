import 'package:flutter/material.dart';
import 'package:front_end/kegiatan_relaksasi/detail_card.dart';

class RelaxationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
          bodyMedium: TextStyle(fontSize: 14),
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class RelaxationScreen extends StatefulWidget {
  @override
  _RelaxationScreenState createState() => _RelaxationScreenState();
}

class _RelaxationScreenState extends State<RelaxationScreen> {
  String selectedCategory = '';
  String selectedDuration = '';
  String searchQuery = '';

  void _showFilterModal() {
    // (Kode modal filter tetap sama)
  }

  final List<Map<String, dynamic>> activities = [
    {
      'title': 'Deep Breathing',
      'duration': '3 minutes',
      'benefit': 'Reduce stress, calm nerves',
      'category': 'Meditation',
      'image': 'assets/image/deep_breath.jpg',
      'categoryColor': Colors.green,
      'description':
          'Deep breathing helps slow the rhythm, promoting relaxation. Sit comfortably, inhale deeply to expand your belly, hold briefly, and exhale slowly. Each breath brings calm, reduces stress, and boosts oxygen, leaving a sense of peace.',
    },
    {
      'title': 'Mindfulness Meditation',
      'duration': '10 minutes',
      'benefit': 'Increase focus, reduce anxiety',
      'category': 'Meditation',
      'image': 'assets/image/meditation.jpg',
      'categoryColor': Colors.green,
      'description':
          'Mindfulness meditation helps you stay present by focusing on your breath and surroundings. This practice encourages a state of awareness and calm, making it effective in reducing anxiety and improving concentration. By dedicating a few moments to mindfulness, you can experience greater mental clarity, emotional balance, and a deeper sense of peace.',
    },
    {
      'title': 'Relaxing Music Listening',
      'duration': '15 minutes',
      'benefit': 'Reduce stress, calm the mind',
      'category': 'Focus',
      'image': 'assets/image/listening_music.jpg',
      'categoryColor': Colors.purple,
      'description':
          'Listening to relaxing music is a simple yet powerful way to soothe your mind and body. The gentle melodies help reduce stress, calm your emotions, and create a tranquil atmosphere. This activity can enhance focus, uplift your mood, and provide a refreshing mental break from daily pressures.',
    },
  ];

  List<Map<String, dynamic>> get filteredActivities {
    if (searchQuery.isEmpty) {
      return activities;
    } else {
      return activities
          .where(
            (activity) => activity['title'].toLowerCase().contains(
                  searchQuery.toLowerCase(),
                ),
          )
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Container kiri kosong
            Container(
              width: 40, // Sesuaikan ukuran jika perlu
              height: 40,
              color: Colors.transparent, // Kosong tanpa icon
            ),

            // Container tengah dengan teks
            Container(
              child: Text(
                'Kegiatan Relaksasi',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Container kanan dengan icon notifikasi
            Container(
              child: IconButton(
                icon: Icon(Icons.notifications_outlined, color: Colors.black),
                onPressed: () {
                  // Aksi untuk notifikasi
                  print('Notifikasi ditekan');
                },
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: Color(0xFFffffff),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Search TextField
              TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search activities...',
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.filter_list),
                    onPressed: _showFilterModal,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              // List of Cards
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: ListView.builder(
                    itemCount: filteredActivities.length,
                    itemBuilder: (context, index) {
                      final activity = filteredActivities[index];
                      return RelaxationCard(
                        title: activity['title'],
                        duration: activity['duration'],
                        benefit: activity['benefit'],
                        category: activity['category'],
                        image: activity['image'],
                        categoryColor: activity['categoryColor'],
                        description: activity['description'],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RelaxationCard extends StatelessWidget {
  final String title;
  final String duration;
  final String benefit;
  final String category;
  final String image;
  final Color categoryColor;
  final String description;

  RelaxationCard({
    required this.title,
    required this.duration,
    required this.benefit,
    required this.category,
    required this.image,
    required this.categoryColor,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(
              title: title,
              duration: duration,
              benefit: benefit,
              category: category,
              image: image,
              categoryColor: categoryColor,
              description: description,
            ),
          ),
        );
      },
      child: Card(
        color: Color(0xffffffff),
        margin: EdgeInsets.only(bottom: 16.0, top: 16.0),
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(color: Color(0xff1B3C73), width: 1.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Left Container (Text Details)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 16.0, color: Colors.grey),
                        SizedBox(width: 4.0), // Spasi antara icon dan text
                        Text(
                          duration,
                          style: TextStyle(fontSize: 14.0, color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Text(benefit, style: TextStyle(fontSize: 14.0)),
                    SizedBox(height: 8.0),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 4.0,
                        horizontal: 8.0,
                      ),
                      decoration: BoxDecoration(
                        color: categoryColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.0),
              // Right Container (Image)
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
