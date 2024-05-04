import 'package:clean_arch_flutter/feature/daily_news/domain/usecases/get_article.dart';
import 'package:clean_arch_flutter/feature/home/domain/usecases/get_home_data.dart';
import 'package:clean_arch_flutter/feature/home/presentation/bloc/home_data/local/local_home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/resources/data_state.dart';
import 'local_home_event.dart';

class LocalHomeDataBloc extends Bloc<LocalHomeDataEvent, LocalHomeDataState> {
  final GetHomeDataUseCase _getHomeDataUseCase;
  final GetArticleUseCase _getArticlesUseCase;

  LocalHomeDataBloc(this._getHomeDataUseCase, this._getArticlesUseCase)
      : super(const LocalHomeDataLoading()) {
    on<GetHomeData>(onGetHomeData);
    on<GetDailyNews>(onGetDailyNews);
  }

  void onGetHomeData(
      GetHomeData event, Emitter<LocalHomeDataState> emit) async {
    final dataState = await _getHomeDataUseCase();
    if (dataState is DataSuccess) {
      print('success ${dataState.data}');
      emit(LocalHomeDataLoadingDone(dataState.data!));
    }
    if (dataState is DataFailed) {
      print('error ${dataState.error!.message}');
      emit(LocalHomeDataLoadingDone(dataState.data!));
    }
  }

  void onGetDailyNews(
      GetDailyNews event, Emitter<LocalHomeDataState> emit) async {
    emit(const RemoteArticlesLoading());
    final dataState = await _getArticlesUseCase();
    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      // print('success ${dataState.data}');
      emit(RemoteDailyNewsLoadingDone(dataState.data!));
    }
    if (dataState is DataFailed) {
      print('error ${dataState.error!.message}');
      emit(RemoteArticlesError(dataState.error!));
    }
  }
}
