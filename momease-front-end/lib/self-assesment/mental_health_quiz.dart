import 'package:flutter/material.dart';
import 'package:front_end/self-assesment/question_page.dart';

class MentalHealthQuizPage extends StatefulWidget {
  @override
  _MentalHealthQuizPageState createState() => _MentalHealthQuizPageState();
}

class _MentalHealthQuizPageState extends State<MentalHealthQuizPage> {
  final List<String> allQuestions = [
    "I often feel overwhelmed with the responsibilities of taking care of my baby, and it feels like too much to handle.",
    "I find it difficult to sleep even when my baby is sleeping, as my mind is restless and anxious.",
    "I frequently worry about my baby's health or safety, even in situations where everything seems fine.",
    "I feel like I have lost my sense of self or personal identity since becoming a mother.",
    "I experience sadness or find myself crying for reasons that I cannot explain.",
    "I feel a lack of support from my close family or friends, which makes things harder for me.",
    "I struggle to form an emotional bond or connection with my baby, and it makes me feel guilty.",
    "I often feel ashamed or guilty for the thoughts or emotions I have about motherhood.",
    "I find myself getting easily frustrated or angry with my partner or other family members.",
    "I feel physically and emotionally exhausted every single day, as though I have nothing left to give.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: QuestionPage(
        questions: allQuestions,
        questionIndex: 0,
        userAnswers: [],
      ),
    );
  }
}
