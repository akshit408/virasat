import 'package:dio/dio.dart';
import 'api_client.dart';
import '../models/festival_model.dart';

class FestivalRepository {
  final Dio _dio = ApiClient.instance.dio;

  Future<List<FestivalModel>> getFestivals() async {
    try {
      final response = await _dio.get('/festivals');
      if (response.statusCode == 200 && response.data['festivals'] != null) {
        final List list = response.data['festivals'];
        return list.map((item) => FestivalModel.fromJson(item)).toList();
      }
    } catch (_) {}
    return [];
  }

  Future<List<FestivalModel>> getCurrentFestivals() async {
    try {
      final response = await _dio.get('/festivals/current');
      if (response.statusCode == 200 && response.data['festivals'] != null) {
        final List list = response.data['festivals'];
        return list.map((item) => FestivalModel.fromJson(item)).toList();
      }
    } catch (_) {}
    return [];
  }
}
