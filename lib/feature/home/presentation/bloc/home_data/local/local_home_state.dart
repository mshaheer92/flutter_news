import 'package:clean_arch_flutter/feature/daily_news/domain/entities/article.dart';
import 'package:clean_arch_flutter/feature/home/domain/entities/home_data.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';

abstract class LocalHomeDataState extends Equatable {
  final HomeDataEntity? homeDataEntity;
  final List<ArticleEntity>? articles;
  final DioException? error;

  const LocalHomeDataState({this.homeDataEntity, this.articles, this.error});

  @override
  List<Object?> get props => [homeDataEntity, articles!, error!];
}

class LocalHomeDataLoading extends LocalHomeDataState {
  const LocalHomeDataLoading();
}

class LocalHomeDataLoadingDone extends LocalHomeDataState {
  const LocalHomeDataLoadingDone(HomeDataEntity homeData)
      : super(homeDataEntity: homeData);
}

class RemoteArticlesLoading extends LocalHomeDataState {
  const RemoteArticlesLoading();
}

class RemoteDailyNewsLoadingDone extends LocalHomeDataState {
  const RemoteDailyNewsLoadingDone(List<ArticleEntity> articles)
      : super(articles: articles);
}

class RemoteArticlesError extends LocalHomeDataState {
  const RemoteArticlesError(DioException exception) : super(error: exception);
}