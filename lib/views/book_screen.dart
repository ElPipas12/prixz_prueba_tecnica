import 'package:app_bar_with_search_switch/app_bar_with_search_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_prixz/view_models/book_viewmodel.dart';
import 'package:flutter_prixz/views/book_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../core/sevices/api_books.dart';

class BookScreen extends StatelessWidget {
  const BookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBarWithSearchSwitch(
        backgroundColor: Colors.indigo, 
        foregroundColor: Colors.white,
        title: (context) {
          final AppBarWithSearchSwitch mainWidget = AppBarWithSearchSwitch.of(context)!;
          Provider.of<BookViewModel>(context, listen: false).searchController = mainWidget.textEditingController;
          return TextField(
            focusNode: mainWidget.searchFocusNode,
            keyboardType: mainWidget.keyboardType,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: "Buscar",
              hintStyle: TextStyle(color: Colors.white),
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              border: InputBorder.none,
            ),
            onSubmitted: mainWidget.submitCallbackForTextField,
            autofocus: true,
            controller: mainWidget.textEditingController,
          );
        },
        onSubmitted: (value) {
          Provider.of<BookViewModel>(context, listen: false).searchBooks();
        },
        appBarBuilder: (BuildContext context) {
          int? total = Provider.of<BookViewModel>(context, listen: true).total;
          return AppBar(
            title: Text(total == null ? 'Libros' : 'Coincidencias: $total'),
            backgroundColor: Colors.indigoAccent,
            foregroundColor: Colors.white,
            actions: [
              const AppBarSearchButton(
                toolTipStartText: "Buscar",
                buttonHasTwoStates: false,
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context, 
                    useSafeArea: true,
                    useRootNavigator: false,
                    builder: (context) {
                      return SizedBox(
                        height: 300,
                        child: Card(
                          child: Consumer<BookViewModel>(
                            builder: (context, c, _) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text("FILTRO", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
                                    ListTile(
                                      title: const Text('Titulo'),
                                      leading: Radio<TypeSearchApiBook?>(
                                        value: TypeSearchApiBook.title,
                                        groupValue: c.type,
                                        toggleable: true,
                                        onChanged: (TypeSearchApiBook? value) {
                                          c.setType(value);
                                        },
                                      ),
                                    ),
                                    ListTile(
                                      title: const Text('Autor'),
                                      leading: Radio<TypeSearchApiBook?>(
                                        value: TypeSearchApiBook.author,
                                        groupValue: c.type,
                                        toggleable: true,
                                        onChanged: (TypeSearchApiBook? value) {
                                          c.setType(value);
                                        },
                                      ),
                                    ),
                                    ListTile(
                                      title: const Text('Cualquiera'),
                                      leading: Radio<TypeSearchApiBook?>(
                                        value: null,
                                        groupValue: c.type,
                                        toggleable: true,
                                        onChanged: (TypeSearchApiBook? value) {
                                          c.setType(value);
                                        },
                                      ),
                                    ),
                                    const Expanded(child: SizedBox()),
                                    OutlinedButton(
                                      onPressed: () => Navigator.pop(context), 
                                      child: const SizedBox(width: double.infinity, child: Text("Cerrar", textAlign: TextAlign.center,))
                                    )
                                  ],
                                ),
                              );
                            }
                          ),
                        ),
                      );
                    },
                  );
                }, 
                icon: const Icon(Icons.filter_alt)
              )
            ],
          );
        },
      ),
      body:  Column(
        children: [
          Expanded(
            child: Consumer<BookViewModel>(
              builder: (context, c, child) {
                if(c.status == StatusBookViewModel.idle) {
                  return const _Message(text: "BUSCA UN LIBRO");
                } else if(c.status == StatusBookViewModel.loading && c.books.isEmpty) {
                  return const Column(
                    children: [
                      LinearProgressIndicator(),
                    ],
                  );
                } else if(c.status == StatusBookViewModel.error) {
                  return const _Message(text: "ERROR AL BUSCAR LOS LIBROS",);
                } else if(c.status == StatusBookViewModel.done || (c.status == StatusBookViewModel.loading && c.books.isNotEmpty)) {

                  if(c.books.isEmpty) return const _Message(text: "NO SE ENCONTRARON LOS LIBROS",);
                  
                  return Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Column(
                            children: [
                              ResponsiveGridRow(
                                children: c.books.map(
                                  (e) => ResponsiveGridCol(
                                    lg: 3,
                                    md: 6,
                                    xs: 6,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                      child: GestureDetector(
                                        onTap: () => Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => BookDetailsScreen(book: e),
                                          )
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(4),
                                          child: Stack(
                                            children: [
                                              Image.network(
                                                e.coverUrl,
                                                width: double.infinity,
                                                height: 250,
                                                fit: BoxFit.cover,
                                                alignment: Alignment.topCenter,
                                              ),
                                              SizedBox(
                                                height: 250,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 4),
                                                      alignment: Alignment.center,
                                                      height: 52,
                                                      width: double.infinity,
                                                      decoration: const BoxDecoration(color: Colors.indigoAccent),
                                                      child: Text(
                                                        e.title, 
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                        textAlign: TextAlign.center,
                                                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
                                                      )
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  )
                                ).toList()
                              ),
                              if(c.status == StatusBookViewModel.loading)
                              Container(
                                height: 64,
                                alignment: Alignment.center,
                                child: const CircularProgressIndicator()
                              )
                              else if(c.offset < (c.total ?? 0))
                              Container(
                                margin: const EdgeInsets.only(bottom: 32, top: 12),
                                child: OutlinedButton(
                                  onPressed:  () {
                                    c.searchMore();
                                  }, 
                                  child: const SizedBox(
                                    width: double.infinity,
                                    child: Text("Ver más", textAlign: TextAlign.center,)
                                  )
                                ),
                              )
                              else
                              const SizedBox(height: 32,)
                            ],
                          )
                        ),
                      ),
                      
                    ],
                  );
                }
                return const SizedBox();
              },
            )
          )
        ],
      )
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(text, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w400),));
  }
}