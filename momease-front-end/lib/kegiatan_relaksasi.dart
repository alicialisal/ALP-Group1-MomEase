import 'package:flutter/material.dart';

class KegiatanRelaksasi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Kegiatan Relaksasi",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pilih Kegiatan Relaksasi",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildRelaxationCard(
                    context,
                    title: "Meditasi",
                    description:
                        "Latih ketenangan pikiran dengan panduan meditasi.",
                    icon: Icons.self_improvement,
                    onTap: () {
                      // Arahkan ke halaman Meditasi
                      print("Navigasi ke Meditasi");
                    },
                  ),
                  _buildRelaxationCard(
                    context,
                    title: "Latihan Pernapasan",
                    description:
                        "Pelajari teknik pernapasan untuk mengurangi stres.",
                    icon: Icons.air,
                    onTap: () {
                      // Arahkan ke halaman Latihan Pernapasan
                      print("Navigasi ke Latihan Pernapasan");
                    },
                  ),
                  _buildRelaxationCard(
                    context,
                    title: "Jurnal Emosi",
                    description:
                        "Tulis perasaanmu untuk membantu mengelola emosi.",
                    icon: Icons.book,
                    onTap: () {
                      // Arahkan ke halaman Jurnal Emosi
                      print("Navigasi ke Jurnal Emosi");
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRelaxationCard(BuildContext context,
      {required String title,
      required String description,
      required IconData icon,
      required VoidCallback onTap}) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.pink[100],
                child: Icon(icon, color: Colors.white, size: 30),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
