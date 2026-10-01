import 'package:dio/dio.dart';
import 'api_client.dart';
import '../models/artisan_model.dart';

import '../services/supabase_service.dart';

class ArtisanRepository {
  final Dio _dio = ApiClient.instance.dio;

  Future<List<ArtisanModel>> getArtisans() async {
    try {
      final supaArtisans = await SupabaseService.getArtisans();
      if (supaArtisans.isNotEmpty) return supaArtisans;
    } catch (_) {}
    try {
      final response = await _dio.get('/artisans');
      if (response.statusCode == 200 && response.data['artisans'] != null) {
        final List list = response.data['artisans'];
        return list.map((item) => ArtisanModel.fromJson(item)).toList();
      }
    } catch (_) {}
    return [];
  }

  Future<ArtisanModel?> getArtisanById(String id) async {
    try {
      final supaArtisan = await SupabaseService.getArtisanById(id);
      if (supaArtisan != null) return supaArtisan;
    } catch (_) {}
    try {
      final response = await _dio.get('/artisans/$id');
      if (response.statusCode == 200 && response.data['artisan'] != null) {
        return ArtisanModel.fromJson(response.data['artisan']);
      }
    } catch (_) {}
    return null;
  }
}
