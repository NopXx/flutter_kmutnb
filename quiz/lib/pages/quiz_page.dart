import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz/models/quiz.dart';
import 'package:quiz/pages/answer_page.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<dynamic> _selected = [];
  late List<QuizModel> quiz = [];

  List shuffle(List items) {
    var random = Random();
    for (var i = items.length - 1; i > 0; i--) {
      var n = random.nextInt(i + 1);

      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }
    return items;
  }

  void loadjson() async {
    final String response =
        await rootBundle.loadString("assets/json/data.json");
    final jsdata = quizModelFromJson(response);
    setState(() {
      quiz = jsdata;
      shuffle(quiz);
      for (var q in quiz) {
        shuffle(q.choice);
      }
      _selected = List<int?>.filled(quiz.length - 3, null);
    });
  }

  @override
  void initState() {
    super.initState();
    loadjson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Test'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadjson,
          ),
        ],
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          quiz.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                      itemCount: quiz.length - 3,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${index + 1} : ${quiz[index].title}'),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: quiz[index].choice.length,
                                itemBuilder: (context, idx) {
                                  return ListTile(
                                    leading: Radio(
                                      value: idx,
                                      groupValue: _selected[index],
                                      toggleable: true,
                                      onChanged: (value) {
                                        setState(() {
                                          _selected[index] = value!;
                                        });
                                      },
                                    ),
                                    title: Text(quiz[index].choice[idx].title),
                                  );
                                },
                              ),
                              const Divider()
                            ],
                          ),
                        );
                      }),
                )
              : Container(),
          const SizedBox(
            height: 16.0,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 0, 16),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: ElevatedButton(
                  onPressed: () {
                    int score = 0;
                    for (int i = 0; i < quiz.length - 3; i++) {
                      if (_selected[i] != null &&
                          quiz[i].choice[_selected[i]].id == quiz[i].answerId) {
                        score++;
                      }
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AnswerPage(
                            score: score,
                            total: quiz.length - 3,
                          ),
                        ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
