import 'package:bson/bson.dart';
import 'package:flutter/material.dart';
import '../models/blog.dart';
import '../controllers/blog_controller.dart';

class BlogCreateScreen extends StatefulWidget {
  @override
  _BlogCreateScreenState createState() => _BlogCreateScreenState();
}

class _BlogCreateScreenState extends State<BlogCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String content = '';
  String author = '';

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      ObjectId blogId = ObjectId();

      Blog blog = Blog(
        id: blogId.toHexString(),
        title: title,
        content: content,
        author: author,
      );

      try {
        await BlogController().createBlog(blog);
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
          'Create Blog',
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
                "Enter Blog Details",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
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
                    'Create Blog',
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
