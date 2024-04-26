import 'package:equatable/equatable.dart';

class HomeDataEntity extends Equatable {
  final String? userId;
  final String? userName;

  const HomeDataEntity(this.userId, this.userName);

  @override
  List<Object?> get props {
    return [userId, userName];
  }
}