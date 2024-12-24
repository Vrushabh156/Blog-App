import 'package:flutter/material.dart';
import '../controllers/blog_controller.dart';
import '../models/blog.dart';
import 'blog_detail_screen.dart';
import 'create_blog_screen.dart';

class BlogListScreen extends StatefulWidget {
  @override
  _BlogListScreenState createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen> {
  late Future<List<Blog>> blogs;

  @override
  void initState() {
    super.initState();
    blogs = BlogController().fetchBlogs();
  }

  void _navigateToForm([Blog? blog]) async {
    bool? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlogCreateScreen(),
      ),
    );
    if (result == true) {
      setState(() {
        blogs = BlogController().fetchBlogs();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Blog List',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: FutureBuilder<List<Blog>>(
        future: blogs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No blogs found.', style: TextStyle(fontSize: 18)));
          } else {
            final blogList = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: blogList.length,
              itemBuilder: (context, index) {
                final blog = blogList[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(
                      blog.title,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'By ${blog.author}',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              blog.content,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        )

                    ),
                    trailing: const Icon(Icons.arrow_forward_ios,
                        color: Colors.deepPurple),
                    onTap: () async {
                      bool? updated = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BlogDetailScreen(blogId: blog.id),
                        ),
                      );
                      if (updated == true) {
                        setState(() {
                          blogs = BlogController().fetchBlogs();
                        });
                      }
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
