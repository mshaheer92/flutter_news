import 'package:clean_arch_flutter/core/resources/data_state.dart';
import 'package:clean_arch_flutter/feature/home/domain/entities/home_data.dart';

abstract class HomeDataRepository {
  Future<DataState<HomeDataEntity>> getHomeData();
}