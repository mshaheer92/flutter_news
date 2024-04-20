import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clean_arch_flutter/core/resources/data_state.dart';
import 'package:clean_arch_flutter/feature/daily_news/domain/usecases/get_article.dart';
import 'package:clean_arch_flutter/feature/daily_news/presentation/bloc/article/remote/remote_article_state.dart';

import 'remote_article_event.dart';

class RemoteArticlesBloc extends Bloc<RemoteArticleEvent, RemoteArticleState> {
  final GetArticleUseCase _getArticlesUseCase;

  RemoteArticlesBloc(this._getArticlesUseCase)
      : super(const RemoteArticlesLoading()) {
    on<GetArticles>(onGetArticles);
  }

  void onGetArticles(
      GetArticles event, Emitter<RemoteArticleState> emit) async {
    final dataState = await _getArticlesUseCase();
    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      print('success ${dataState.data}');
      emit(RemoteArticlesDone(dataState.data!));
    }
    if (dataState is DataFailed) {
      print('error ${dataState.error!.message}');
      emit(RemoteArticlesError(dataState.error!));
    }
  }
}
