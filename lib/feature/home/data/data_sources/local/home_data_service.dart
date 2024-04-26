import 'package:clean_arch_flutter/feature/home/domain/entities/home_data.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomeDataLocalService {
  final storage = const FlutterSecureStorage();

  Future<void> saveHomeData(String userId, String userName) async {
    await storage.write(key: 'userId', value: userId);
    await storage.write(key: 'userName', value: userName);
  }

  Future<HomeDataEntity?> readHomeData() async {
    String? userName = await storage.read(key: 'userName');
    String? userId = await storage.read(key: 'userId');
    return HomeDataEntity(userId, userName);
  }

  Future<void> clearUserData() async {
    await storage.delete(key: 'userId');
    await storage.delete(key: 'userName');
  }
}
