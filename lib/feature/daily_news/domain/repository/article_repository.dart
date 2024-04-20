import 'package:clean_arch_flutter/core/resources/data_state.dart';
import 'package:clean_arch_flutter/feature/daily_news/domain/entities/article.dart';

abstract class ArticleRepository {
  Future<DataState<List<ArticleEntity>>> getNewsArticles();
}