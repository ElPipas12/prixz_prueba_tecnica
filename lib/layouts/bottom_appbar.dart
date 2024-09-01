import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_prixz/views/book_screen.dart';
import 'package:flutter_prixz/views/user_form_screen.dart';
import 'package:provider/provider.dart';

import '../view_models/appbar_viewmodel.dart';


class BottomAppBarLayout extends StatelessWidget {
  const BottomAppBarLayout({super.key});

  @override
  Widget build(BuildContext context) {

    const List<Widget> pages = [
      BookScreen(),
      UserFormScreen(),
    ];

    return Scaffold(
      body: Consumer<AppBarViewModel>(
        builder: (context, value, child) {
          return pages[value.index];
        },
      ),
      bottomNavigationBar: ConvexAppBar(
        activeColor: Colors.white,
        color: Colors.white,
        backgroundColor: Colors.indigoAccent,
        style: TabStyle.react,
        items: const [
          TabItem(icon: Icons.book, title: 'Libros'),
          TabItem(icon: Icons.people, title: 'Usuario')
        ],
        onTap: (int i) => Provider.of<AppBarViewModel>(context, listen: false).setIndex(i),
      )
    );
  }
}