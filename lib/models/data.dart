import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class Data {
  final String question;
  final List<String> answers;
  final int correctIndex;

  Data({
    required this.question,
    required this.answers,
    required this.correctIndex,
  });

  factory Data.fromJson(Map<String, dynamic> json) =>
      _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class Level {
  final int id;
  final String title;
  final String image;
  final List<Data> questions;

  Level({
    required this.id,
    required this.title,
    required this.image,
    required this.questions,
  });

  factory Level.fromJson(Map<String, dynamic> json) =>
      _$LevelFromJson(json);

  Map<String, dynamic> toJson() => _$LevelToJson(this);
}