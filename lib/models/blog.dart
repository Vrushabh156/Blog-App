import 'package:bson/bson.dart';

class Blog {
  final String id;
  final String title;
  final String content;
  final String author;

  Blog({required this.id, required this.title, required this.content, required this.author});

  // Convert JSON to Blog object
  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      author: json['author'],
    );
  }

  // Convert Blog object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'author': author,
    };
  }
}
