import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clean_arch_flutter/feature/daily_news/domain/entities/article.dart';
import 'package:clean_arch_flutter/feature/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:clean_arch_flutter/feature/daily_news/presentation/bloc/article/remote/remote_article_state.dart';

class DailyNews extends StatelessWidget {
  const DailyNews({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  _buildAppBar() {
    return AppBar(
        title: const Text('Daily News', style: TextStyle(color: Colors.black)));
  }

  _buildBody() {
    return BlocBuilder<RemoteArticlesBloc, RemoteArticleState>(
        builder: (_, state) {
      if (state is RemoteArticlesLoading) {
        return const Center(
          child: CupertinoActivityIndicator(),
        );
      }
      if (state is RemoteArticlesError) {
        return const Center(
          child: Icon(Icons.refresh),
        );
      }
      if (state is RemoteArticlesDone) {
        final articles = state.articles!;
        return ListView.separated(
            itemCount: state.articles!.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return _buildNewsItem(article, context);
            },
            separatorBuilder: (context, index) => const Divider());
      }
      return const SizedBox();
    });
  }

  Widget _buildNewsItem(ArticleEntity article, BuildContext context) {
    double imageHeight = ((16.0 * 3) + (12 * 2) + 35);
    double imageWidth = MediaQuery.of(context).size.width / 3;
    String imageURL = '${article.urlToImage}';
    print('URL : $imageURL');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      margin: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align top for image
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: SizedBox(
              width: imageWidth,
              height: imageHeight, // Adjust height as needed
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/images/placeholder.png',
                // Placeholder image
                image: imageURL ?? '',
                // Handle null image URLs
                fit: BoxFit.cover, // Cover the container
              ),
            ),
          ),
          const SizedBox(width: 16.0), // Spacing between image and text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title ?? '',
                  maxLines: 3,
                  // Limit to 3 lines
                  overflow: TextOverflow.ellipsis,
                  // Handle overflow with ellipsis
                  style: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5.0),
                // Spacing between title and description
                Text(
                  article.description ?? '',
                  maxLines: 2, // Limit to 2 lines
                  overflow:
                      TextOverflow.ellipsis, // Handle overflow with ellipsis
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
