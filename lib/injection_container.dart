import 'package:clean_arch_flutter/feature/daily_news/data/data_sources/remote/news_api_service.dart';
import 'package:clean_arch_flutter/feature/daily_news/data/repository/article_repository.dart';
import 'package:clean_arch_flutter/feature/daily_news/domain/repository/article_repository.dart';
import 'package:clean_arch_flutter/feature/daily_news/domain/usecases/get_article.dart';
import 'package:clean_arch_flutter/feature/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:clean_arch_flutter/feature/home/data/data_sources/local/home_data_service.dart';
import 'package:clean_arch_flutter/feature/home/data/repositories/home_data_repository.dart';
import 'package:clean_arch_flutter/feature/home/domain/repository/home_data_repository.dart';
import 'package:clean_arch_flutter/feature/home/domain/usecases/get_home_data.dart';
import 'package:clean_arch_flutter/feature/home/presentation/bloc/home_data/local/local_home_bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

Future<void> initializeDependencies() async {
  sl.registerSingleton<Dio>(Dio());

  sl.registerSingleton<NewsApiService>(NewsApiService(sl()));
  sl.registerSingleton<ArticleRepository>(ArticleRepositoryImpl(sl()));
  sl.registerSingleton<GetArticleUseCase>(GetArticleUseCase(sl()));
  sl.registerFactory<RemoteArticlesBloc>(() => RemoteArticlesBloc((sl())));

  sl.registerSingleton<HomeDataLocalService>(HomeDataLocalService());
  sl.registerSingleton<HomeDataRepository>(HomeDataRepositoryImpl(sl()));
  sl.registerSingleton<GetHomeDataUseCase>(GetHomeDataUseCase(sl()));
  sl.registerSingleton<LocalHomeDataBloc>(LocalHomeDataBloc(sl(), sl()));
}
