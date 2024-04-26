import 'package:clean_arch_flutter/core/resources/data_state.dart';
import 'package:clean_arch_flutter/feature/home/data/data_sources/local/home_data_service.dart';
import 'package:clean_arch_flutter/feature/home/domain/entities/home_data.dart';
import 'package:clean_arch_flutter/feature/home/domain/repository/home_data_repository.dart';
import 'package:dio/dio.dart';

class HomeDataRepositoryImpl implements HomeDataRepository {
  final HomeDataLocalService _homeDataLocalService;

  HomeDataRepositoryImpl(this._homeDataLocalService);

  @override
  Future<DataState<HomeDataEntity>> getHomeData() async {
    try {
      final homeData = await _homeDataLocalService.readHomeData();
      return DataSuccess(homeData!);
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }
}
