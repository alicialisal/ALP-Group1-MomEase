import 'package:flutter/material.dart';
import 'package:front_end/chatbot.dart';
import 'package:front_end/kegiatan_relaksasi.dart';
import 'package:front_end/mood_journaling.dart';
import 'package:front_end/profile.dart';

class ResultPage extends StatelessWidget {
  final List<String?> userAnswers;

  ResultPage({required this.userAnswers});

  @override
  Widget build(BuildContext context) {
    int calculateScore() {
      int score = 0;

      for (var answer in userAnswers) {
        switch (answer) {
          case "Very often":
            score += 10;
            break;
          case "Often":
            score += 8;
            break;
          case "Sometimes":
            score += 5;
            break;
          case "Rarely":
            score += 2;
            break;
          case "Never":
            score += 0;
            break;
          default:
            break;
        }
      }
      return score;
    }

    String analyzeScore(int score) {
      if (score >= 95) {
        return "Based on your self-assessment results, you are at VERY SERIOUS risk of experiencing Baby Blues Syndrome.";
      } else if (score >= 55) {
        return "Based on your self-assessment results, you are at QUITE SERIOUS risk of experiencing Baby Blues Syndrome.";
      } else if (score <= 55 && score > 49) {
        return "Based on your self-assessment results, you are at MIDDLE risk of experiencing Baby Blues Syndrome.";
      } else if (score <= 49 && score > 0) {
        return "Based on your self-assessment results, you are at QUITE LOW risk of experiencing Baby Blues Syndrome.";
      } else if (score <= 25 && score > 0) {
        return "Based on your self-assessment results, you are at VERY LOW risk of experiencing Baby Blues Syndrome.";
      } else {
        return "There is no risk of experiencing baby blues.";
      }
    }

    int finalScore = calculateScore();
    String resultMessage = analyzeScore(finalScore);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60), // Tinggi header
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leadingWidth: 100, // Tambahkan ruang untuk leading
          leading: InkWell(
            onTap: () {
              // Navigasi ke halaman profil
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  padding: EdgeInsets.zero, // Hapus padding internal
                  onPressed:
                      null, // Tidak diperlukan karena InkWell menangani onTap
                ),
                Flexible(
                  child: Text(
                    "Back",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis, // Hindari overflow
                  ),
                ),
              ],
            ),
          ),
          centerTitle: false,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: SingleChildScrollView(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              // Mengambil lebar maksimal dari layout
              double maxWidth = constraints.maxWidth;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFFBCD9),
                    ),
                    child: Center(
                      child: Text(
                        "$finalScore",
                        style: TextStyle(
                          fontSize: 75,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: IntrinsicWidth(
                      child: IntrinsicHeight(
                        child: Text(
                          resultMessage,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Button 1
                  SizedBox(
                    width: maxWidth,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => KegiatanRelaksasi(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(color: Color(0xFFFFBCD9), width: 3),
                        backgroundColor: Color(0xFFffffff),
                        padding: EdgeInsets.all(16),
                        elevation: 6,
                        shadowColor: Colors.black.withOpacity(0.8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/relaxation.png',
                            height: 80,
                            width: 80,
                          ),
                          SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              "Calm your mind with our activities.",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  // Button 2
                  SizedBox(
                    width: maxWidth,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MoodJournaling()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(color: Color(0xFFFFBCD9), width: 3),
                        backgroundColor: Color(0xFFffffff),
                        padding: EdgeInsets.all(16),
                        elevation: 6,
                        shadowColor: Colors.black.withOpacity(0.8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/mood_journaling.png',
                            height: 80,
                            width: 80,
                          ),
                          SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              "Express your mood here.",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  // Button 3
                  SizedBox(
                    width: maxWidth,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatBotPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(color: Color(0xFFFFBCD9), width: 3),
                        backgroundColor: Color(0xFFffffff),
                        padding: EdgeInsets.all(16),
                        elevation: 6,
                        shadowColor: Colors.black.withOpacity(0.8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/chatbot.png',
                            height: 80,
                            width: 80,
                          ),
                          SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              "Tell us about what you feel.",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 50),

                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 30.0,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Let's prevent Baby Blues Syndrome and maintain your mental health with MomEase!",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        color: Color(0xFF808080),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(height: 24),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
