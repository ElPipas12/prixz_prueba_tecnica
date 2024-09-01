
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_prixz/core/sevices/api_books.dart';
import 'package:flutter_prixz/models/book_model.dart';
import 'package:http/http.dart';

enum StatusBookViewModel {
  idle,
  loading,
  error,
  done
}

class BookViewModel extends ChangeNotifier {

  StatusBookViewModel status = StatusBookViewModel.idle;
  List<BookModel> books = [];

  int offset = 0;
  final int limit = 48;
  int? total;

  TypeSearchApiBook? type;
  TextEditingController searchController = TextEditingController();

  void setType(TypeSearchApiBook? type) {
    this.type = type;
    notifyListeners();
  }

  Future searchBooks() async {
    status = StatusBookViewModel.loading;
    books = [];
    offset = 0;
    total = null;
    notifyListeners();

    if(searchController.text.isEmpty) {
      status = StatusBookViewModel.idle;
      return;
    }

    
    Response response = await ApiBooks.searchBooks(
      search: searchController.text, 
      type: type, 
      offset: offset, 
      limit: limit
    );

    if(response.statusCode == 200) {
      final data = jsonDecode(response.body);
      books = (data["docs"] as List).map((e) => BookModel.fromJson(e)).toList();
      
      if(searchController.text.isEmpty) {
        status = StatusBookViewModel.idle;
        total = null;
      } else {
        status = StatusBookViewModel.done;
        total = data["numFound"];
      }

    } else {
      if (kDebugMode) print(response.body);

      status = StatusBookViewModel.error;
    }

    notifyListeners();
  }

  Future searchMore() async {
    status = StatusBookViewModel.loading;
    offset = offset + limit;
    notifyListeners();

    Response response = await ApiBooks.searchBooks(
      search: searchController.text, 
      type: type, 
      offset: offset, 
      limit: limit
    );

    if(response.statusCode == 200) {
      final data = jsonDecode(response.body);
      books = books + (data["docs"] as List).map((e) => BookModel.fromJson(e)).toList();
      
      if(searchController.text.isEmpty) {
        status = StatusBookViewModel.idle;
        total = null;
      } else {
        status = StatusBookViewModel.done;
        total = data["numFound"];
      }

    } else {
      status = StatusBookViewModel.error;
    }

    notifyListeners();
  }
}