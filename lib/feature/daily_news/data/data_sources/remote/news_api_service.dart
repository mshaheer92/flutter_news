import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:clean_arch_flutter/core/constants/constants.dart';

import '../../models/article.dart';

part 'news_api_service.g.dart';

@RestApi(baseUrl: newsApiBaseURL)
abstract class NewsApiService {
  factory NewsApiService(Dio dio) = _NewsApiService;

  @GET('/top-headlines')
  Future<HttpResponse<List<ArticleModel>>> getNewsArticles(
      {@Query("apiKey") String? apiKey,
      @Query("country") String? country,
      @Query("category") String? category});
}
