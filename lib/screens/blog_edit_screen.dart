import 'package:flutter/material.dart';
import '../models/blog.dart';
import '../controllers/blog_controller.dart';

class BlogEditScreen extends StatefulWidget {
  final Blog existingBlog;

  BlogEditScreen({required this.existingBlog});

  @override
  _BlogEditScreenState createState() => _BlogEditScreenState();
}

class _BlogEditScreenState extends State<BlogEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String content;
  late String author;

  @override
  void initState() {
    super.initState();
    title = widget.existingBlog.title;
    content = widget.existingBlog.content;
    author = widget.existingBlog.author;
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Blog updatedBlog = Blog(
        id: widget.existingBlog.id,
        title: title,
        content: content,
        author: author,
      );

      try {
        await BlogController().updateBlog(updatedBlog.id, updatedBlog);
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Blog',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Edit Blog Details",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                initialValue: title,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a title' : null,
                onSaved: (value) => title = value!,
              ),
              SizedBox(height: 20),
              TextFormField(
                initialValue: content,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 5,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter content' : null,
                onSaved: (value) => content = value!,
              ),
              SizedBox(height: 20),
              TextFormField(
                initialValue: author,
                decoration: const InputDecoration(
                  labelText: 'Author',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter an author' : null,
                onSaved: (value) => author = value!,
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _submitForm,
                  child: const Text(
                    'Update Blog',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
