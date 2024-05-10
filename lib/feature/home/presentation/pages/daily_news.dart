import 'package:clean_arch_flutter/feature/daily_news/domain/entities/article.dart';
import 'package:clean_arch_flutter/feature/daily_news_detailed/presentation/pages/detailed_news.dart';
import 'package:clean_arch_flutter/feature/home/presentation/bloc/home_data/local/local_home_bloc.dart';
import 'package:clean_arch_flutter/feature/home/presentation/bloc/home_data/local/local_home_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DailyNews extends StatelessWidget {
  const DailyNews({super.key});

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
    return BlocBuilder<LocalHomeDataBloc, LocalHomeDataState>(
        builder: (buildContext, state) {
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
      if (state is RemoteDailyNewsLoadingDone) {
        final articles = state.articles!;
        return ListView.separated(
            itemCount: state.articles!.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return GestureDetector(
                onTap: () {
                  context.go('/details', extra: article);
                },
                child: _buildNewsItem(article, context),
              );
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      margin: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: SizedBox(
              width: imageWidth,
              height: imageHeight,
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/images/img_placeholder.png',
                placeholderScale: .3,
                placeholderFit: BoxFit.scaleDown,
                image: imageURL ?? '',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16.0),
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
