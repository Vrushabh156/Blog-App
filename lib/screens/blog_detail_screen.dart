import 'package:bson/bson.dart';
import 'package:flutter/material.dart';
import '../controllers/blog_controller.dart';
import '../models/blog.dart';
import 'blog_edit_screen.dart';

class BlogDetailScreen extends StatelessWidget {
  final String blogId;

  BlogDetailScreen({required this.blogId});

  void _deleteBlog(BuildContext context) async {
    try {
      await BlogController().deleteBlog(blogId);
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Blog>(
      future: BlogController().fetchBlogById(blogId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasError) {
          return Scaffold(
              body: Center(child: Text('Error: ${snapshot.error}')));
        } else if (!snapshot.hasData) {
          return Scaffold(body: Center(child: Text('Blog not found')));
        } else {
          final blog = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Text(
                blog.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () async {
                    bool? updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BlogEditScreen(existingBlog: blog),
                      ),
                    );
                    if (updated == true) {
                      Navigator.pop(context, true);
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.white),
                  onPressed: () => _deleteBlog(context),
                ),
              ],
              backgroundColor: Colors.deepPurple,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    blog.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'By ${blog.author}',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(thickness: 2),
                  const SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        blog.content,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
