import 'dart:io';

import 'package:dio/dio.dart';
import 'package:clean_arch_flutter/core/constants/constants.dart';
import 'package:clean_arch_flutter/core/resources/data_state.dart';
import 'package:clean_arch_flutter/feature/daily_news/data/data_sources/remote/news_api_service.dart';
import 'package:clean_arch_flutter/feature/daily_news/data/models/article.dart';
import 'package:clean_arch_flutter/feature/daily_news/domain/repository/article_repository.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final NewsApiService _newsApiService;

  ArticleRepositoryImpl(this._newsApiService);

  @override
  Future<DataState<List<ArticleModel>>> getNewsArticles() async {
    try {
      final httpResponse = await _newsApiService.getNewsArticles(
          apiKey: apiKey, country: country, category: category);
      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data);
      } else {
        return DataFailed(DioException(
            requestOptions: httpResponse.response.requestOptions,
            response: httpResponse.response,
            type: DioExceptionType.connectionError,
            error: httpResponse.response.statusMessage));
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }
}
