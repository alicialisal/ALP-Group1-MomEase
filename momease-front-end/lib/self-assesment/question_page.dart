import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:front_end/self-assesment/result_page.dart';

class QuestionPage extends StatefulWidget {
  final List<String> questions;
  final int questionIndex;
  final List<String> userAnswers;

  QuestionPage({
    required this.questions,
    required this.questionIndex,
    required this.userAnswers,
  });

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  final List<String> options = [
    "Very often",
    "Often",
    "Sometimes",
    "Rarely",
    "Never",
  ];

  final Color progressBarColor = Color(0xFFFFBCD9);

  String getStatusMessage(int index) {
    if (index >= 0 && index < 4) {
      return "First step! 😊";
    } else if (index >= 4 && index < 6) {
      return "Half-way done! 😍";
    } else if (index >= 6 && index < 7) {
      return "Keep going! 🥰";
    } else if (index >= 7 && index < 9) {
      return "Almost done! 😎";
    } else if (index == 9) {
      return "Finished! 🥳";
    } else {
      return "Keep going! 🥰";
    }
  }

  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    double progress = (widget.questionIndex + 1) / widget.questions.length;

    // Calculate the maximum width for the options
    double maxWidth = options.map((option) {
      final textPainter = TextPainter(
        text: TextSpan(text: option, style: TextStyle(fontSize: 16)),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      )..layout();
      return textPainter.width;
    }).reduce((a, b) => a > b ? a : b);

    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tombol Back
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(
                        context,
                      ); // Aksi kembali ke layar sebelumnya
                    },
                  ),
                  Text(
                    "Back",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        getStatusMessage(widget.questionIndex),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey[300],
                          color: progressBarColor,
                          minHeight: 10,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Question ${widget.questionIndex + 1} of ${widget.questions.length}",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff808080),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        widget.questions[widget.questionIndex],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      ...options.map(
                        (option) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(
                                maxWidth + 150,
                                53,
                              ), // Set the width based on maxWidth
                              backgroundColor: selectedOption == option
                                  ? Color(0xFF1B3873)
                                  : Colors.white,
                              side: BorderSide(
                                color: Color(0xFF1B3873),
                                width: 2.5,
                              ),
                              foregroundColor: selectedOption == option
                                  ? Colors.white
                                  : Color(0xFF1B3873),
                            ),
                            onPressed: () {
                              setState(() {
                                selectedOption = option;
                              });
                            },
                            child: Text(
                              option,
                              style: TextStyle(
                                color: selectedOption == option
                                    ? Colors.white
                                    : Color(0xFF000000),
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Spacer(), // Menempatkan ruang fleksibel sebelum tombol
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (selectedOption == null) {
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (context) {
                                  return Stack(
                                    children: [
                                      BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: 5,
                                          sigmaY: 5,
                                        ),
                                        child: Container(
                                          color: Colors.black.withAlpha(128),
                                        ),
                                      ),
                                      Center(
                                        child: AlertDialog(
                                          alignment: Alignment.center,
                                          backgroundColor: Colors.white,
                                          contentPadding: EdgeInsets.all(20),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "You've must fill the test!",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 27,
                                                ),
                                              ),
                                              SizedBox(height: 16),
                                              Text(
                                                "The result of your test will be better when all questions were answered",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xFF808080),
                                                ),
                                              ),
                                              SizedBox(height: 24),
                                              SizedBox(
                                                width: double.infinity,
                                                child: TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  style: TextButton.styleFrom(
                                                    backgroundColor: Color(
                                                      0xFF6495ED,
                                                    ),
                                                    foregroundColor:
                                                        Colors.white,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      vertical: 15,
                                                    ),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        10,
                                                      ),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "Okay!",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              if (widget.questionIndex <
                                  widget.questions.length - 1) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => QuestionPage(
                                      questions: widget.questions,
                                      questionIndex: widget.questionIndex + 1,
                                      userAnswers: [
                                        ...widget.userAnswers,
                                        selectedOption!,
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ResultPage(
                                      userAnswers: [
                                        ...widget.userAnswers,
                                        selectedOption,
                                      ],
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF6495ED),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 5,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.questionIndex <
                                        widget.questions.length - 1
                                    ? 'Next Question'
                                    : 'See Result!',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
