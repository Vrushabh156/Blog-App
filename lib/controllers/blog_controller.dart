import 'package:bson/bson.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/blog.dart';

class BlogController {
  final String baseUrl = 'http://192.168.180.234:45550/api/blogs';

  // Fetch all blogs
  Future<List<Blog>> fetchBlogs() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/getall'));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((blog) => Blog.fromJson(blog)).toList();
      } else {
        throw Exception('Failed to load blogs');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Fetch a blog by ID
  Future<Blog> fetchBlogById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/search/$id'));
      if (response.statusCode == 200) {
        return Blog.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load blog');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Create a new blog
  Future<Blog> createBlog(Blog blog) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/save'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(blog.toJson()),
      );

      if (response.statusCode == 200) {
        return Blog.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create blog');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Update an existing blog
  Future<Blog> updateBlog(String id, Blog blog) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/update/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(blog.toJson()),
      );

      if (response.statusCode == 200) {
        return Blog.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update blog');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Delete a blog
  Future<void> deleteBlog(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/delete/$id'));
      if (response.statusCode != 200) {
        throw Exception('Failed to delete blog');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
