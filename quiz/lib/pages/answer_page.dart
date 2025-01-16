// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnswerPage extends StatefulWidget {
  final int score;
  final int total;
  const AnswerPage({required this.score, required this.total, super.key});

  @override
  State<AnswerPage> createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  int quizCount = 0;
  int totalScore = 0;
  int highScore = 0;
  int lowScore = 0;
  int count = 0;

  Future<void> loadData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      highScore = pref.getInt('highScore') ?? 0;
      lowScore = pref.getInt('lowScore') ?? widget.score;
      totalScore = pref.getInt('totalScore') ?? 0;
      quizCount = pref.getInt('quizCount') ?? 0;
      count = pref.getInt('count') ?? 0;

      count++;
      highScore = widget.score > highScore ? widget.score : highScore;
      lowScore = (lowScore == widget.score || widget.score < lowScore)
          ? widget.score
          : lowScore;
      totalScore += widget.score;
      quizCount += widget.total;

      pref.setInt('highScore', highScore);
      pref.setInt('lowScore', lowScore);
      pref.setInt('totalScore', totalScore);
      pref.setInt('quizCount', quizCount);
      pref.setInt('count', count);
    });
  }

  String getGrade(int score, int total) {
    double percentage = (score / total) * 100;
    if (percentage >= 80)
      return 'A';
    else if (percentage >= 70)
      return 'B';
    else if (percentage >= 60)
      return 'C';
    else if (percentage >= 50)
      return 'D';
    else
      return 'F';
  }

  @override
  void initState() {
    super.initState();

    loadData();
  }

  @override
  Widget build(BuildContext context) {
    double percentage = (totalScore / quizCount) * 100;
    String grade = getGrade(totalScore, quizCount);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Answer Page'),
        centerTitle: true,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Results'),
            const SizedBox(
              height: 8.0,
            ),
            _buildCard(context, 'Now', widget.score.toString()),
            const SizedBox(
              height: 8.0,
            ),
            _buildCard(context, 'High Score', highScore.toString()),
            const SizedBox(
              height: 8.0,
            ),
            _buildCard(context, 'Low Score', lowScore.toString()),
            const SizedBox(
              height: 8.0,
            ),
            _buildCard(context, 'Percentage', percentage.toStringAsFixed(2)),
            const SizedBox(
              height: 8.0,
            ),
            _buildCard(context, 'Grade', grade.toString()),
            const SizedBox(
              height: 8.0,
            ),
            _buildCard(context, 'Total Score', totalScore.toString()),
            const SizedBox(
              height: 8.0,
            ),
            _buildCard(context, 'Count', count.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, String number) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(2, 2),
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
          ),
        ],
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(
            width: 8.0,
          ),
          const Text(
            ':',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            width: 8.0,
          ),
          Text(
            number,
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
