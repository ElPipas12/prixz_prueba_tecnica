// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'book_model.g.dart';

@JsonSerializable()
class BookModel {
  final String key, title;
  final dynamic cover_i;
  final List<String>? author_name, first_sentence;
  final num? ratings_average;

  String get coverUrl => "https://covers.openlibrary.org/b/id/$cover_i-M.jpg";

  BookModel({
    required this.key, 
    required this.title, 
    required this.cover_i, 
    required this.author_name,
    required this.first_sentence,
    required this.ratings_average
  });
  factory BookModel.fromJson(Map<String, dynamic> json) => _$BookModelFromJson(json);
  Map<String, dynamic> toJson() => _$BookModelToJson(this);
}