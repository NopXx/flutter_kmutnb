import 'dart:convert';

List<QuizModel> quizModelFromJson(String str) =>
    List<QuizModel>.from(json.decode(str).map((x) => QuizModel.fromJson(x)));

String quizModelToJson(List<QuizModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class QuizModel {
  QuizModel(
      {required this.title, required this.choice, required this.answerId, required this.cover});

  String title;
  List<QuizChoice> choice;
  int answerId;
  String cover;

  factory QuizModel.fromJson(Map<String, dynamic> json) => QuizModel(
        title: json["title"],
        choice: List<QuizChoice>.from(
            json["choice"].map((x) => QuizChoice.fromJson(x))),
        answerId: json["answerId"],
        cover: json["cover"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "choice": List<dynamic>.from(choice.map((e) => e.toJson())),
        "answerId": answerId,
        "cover": cover,
      };
}

class QuizChoice {
  QuizChoice({
    required this.id,
    required this.title,
  });

  int id;
  String title;

  factory QuizChoice.fromJson(Map<String, dynamic> json) => QuizChoice(
        id: json["id"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
      };
}
