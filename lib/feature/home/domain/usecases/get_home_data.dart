import 'package:clean_arch_flutter/core/resources/data_state.dart';
import 'package:clean_arch_flutter/core/usecase/usecase.dart';
import 'package:clean_arch_flutter/feature/home/domain/entities/home_data.dart';
import 'package:clean_arch_flutter/feature/home/domain/repository/home_data_repository.dart';

class GetHomeDataUseCase implements UseCase<DataState<HomeDataEntity>, void> {
  final HomeDataRepository _homeDataRepository;

  GetHomeDataUseCase(this._homeDataRepository);

  @override
  Future<DataState<HomeDataEntity>> call({void params}) {
    return _homeDataRepository.getHomeData();
  }
}