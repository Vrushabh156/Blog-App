import 'package:flutter/material.dart';
import 'screens/blog_list_screen.dart';

void main() {
  runApp(BlogApp());
}

class BlogApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blog App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlogListScreen(),
    );
  }
}
