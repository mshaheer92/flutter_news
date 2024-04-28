import 'package:clean_arch_flutter/feature/daily_news/domain/entities/article.dart';
import 'package:flutter/material.dart';

class DetailedNewsPage extends StatelessWidget {
  final ArticleEntity article;

  const DetailedNewsPage({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily News'),
        actions: <Widget>[
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.bookmark_add_outlined))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                article.title!,
                style: const TextStyle(
                    fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              Text(
                article.description!,
                style: const TextStyle(
                    fontSize: 16.0, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 16.0),
              if (article.urlToImage != null)
                Image.network(article.urlToImage!),
            ],
          ),
        ),
      ),
    );
  }
}