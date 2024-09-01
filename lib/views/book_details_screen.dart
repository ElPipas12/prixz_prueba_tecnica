import 'package:flutter/material.dart';

import '../models/book_model.dart';

class BookDetailsScreen extends StatelessWidget {
  const BookDetailsScreen({
    super.key,
    required this.book
  });

  final BookModel book;

  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;

    const TextStyle titleTextStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.w700);
    const TextStyle bodyTextStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w400);

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.indigo, foregroundColor: Colors.white, title: const Text("DETALLES"),),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              alignment: Alignment.center,
              child: Text(book.title, style: titleTextStyle.copyWith(fontSize: 22), textAlign: TextAlign.center,)
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  book.coverUrl,
                  fit: BoxFit.cover,
                  width: size.width / 2,
                  alignment: Alignment.topCenter,
                ),
                if(book.ratings_average != null)
                ...[
                  const SizedBox(width: 8,),
                  const Icon(Icons.star, color: Colors.amber, size: 48,),
                  Text(book.ratings_average!.toStringAsFixed(2), style: titleTextStyle.copyWith(fontSize: 24),)
                ]
              ],
            ),
            const SizedBox(height: 16,),
            Card(
              surfaceTintColor: Colors.white,
              elevation: 4,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  children: [
                    if(book.first_sentence != null && book.first_sentence!.isNotEmpty)
                    ...[
                      const Text("Parrafo inicial", style: titleTextStyle,),
                      for(String i in book.first_sentence!)
                      Text(i, style: bodyTextStyle, textAlign: TextAlign.justify,),
                      const SizedBox(height: 16,),
                    ],
                    if(book.author_name != null && book.author_name!.isNotEmpty)
                    ...[
                      Text(book.author_name!.length == 1 ? "AUTOR" : "AUTORES", style: titleTextStyle,),
                      for(String i in book.author_name!)
                      Text(i, style: bodyTextStyle,)
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32,)
          ],
        ),
      ),
    );
  }
}