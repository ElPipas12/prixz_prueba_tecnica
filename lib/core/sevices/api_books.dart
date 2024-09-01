import 'package:flutter_prixz/core/constants/api_contants.dart';
import 'package:http/http.dart';

enum TypeSearchApiBook{
  author,
  title
}

// LISTA DE LOS CAMPOS QUE SE MANDAN LLAMAR A LA API PARA OPTIMIZAR
const List<String> fields = [
  "key",
  "title",
  "author",
  "cover_i",
  "author_name",
  "first_sentence",
  "ratings_average",
];

class ApiBooks {
  static Future<Response> searchBooks({
    required String search, 
    required TypeSearchApiBook? type, 
    required int offset, 
    required int limit
  }) async {

    late String typeSearch;

    switch (type) {
      case TypeSearchApiBook.author: typeSearch = "author"; break;
      case TypeSearchApiBook.title: typeSearch = "title"; break;
      default: typeSearch = "q";
    }

    final url = '$urlApiBooks/search.json?$typeSearch=$search&fields=${fields.join(",")}&offset=$offset&limit=$limit';

    return get(Uri.parse(url));
  }
}