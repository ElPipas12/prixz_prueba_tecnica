// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookModel _$BookModelFromJson(Map<String, dynamic> json) => BookModel(
      key: json['key'] as String,
      title: json['title'] as String,
      cover_i: json['cover_i'],
      author_name: (json['author_name'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      first_sentence: (json['first_sentence'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      ratings_average: json['ratings_average'] as num?,
    );

Map<String, dynamic> _$BookModelToJson(BookModel instance) => <String, dynamic>{
      'key': instance.key,
      'title': instance.title,
      'cover_i': instance.cover_i,
      'author_name': instance.author_name,
      'first_sentence': instance.first_sentence,
      'ratings_average': instance.ratings_average,
    };
