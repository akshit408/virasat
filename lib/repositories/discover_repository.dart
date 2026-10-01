import 'package:dio/dio.dart';
import 'api_client.dart';
import '../models/state_model.dart';
import '../models/gi_product_model.dart';

import '../services/supabase_service.dart';

class DiscoverRepository {
  final Dio _dio = ApiClient.instance.dio;

  Future<List<StateModel>> getStates() async {
    try {
      final supaStates = await SupabaseService.getDiscoverStates();
      if (supaStates.isNotEmpty) return supaStates;
    } catch (_) {}
    try {
      final response = await _dio.get('/states');
      if (response.statusCode == 200 && response.data['states'] != null) {
        final List list = response.data['states'];
        return list.map((item) => StateModel.fromJson(item)).toList();
      }
    } catch (_) {}
    return [];
  }

  Future<List<GiProductModel>> getCrafts() async {
    try {
      final supaCrafts = await SupabaseService.getCrafts();
      if (supaCrafts.isNotEmpty) return supaCrafts;
    } catch (_) {}
    try {
      final response = await _dio.get('/crafts');
      if (response.statusCode == 200 && response.data['crafts'] != null) {
        final List list = response.data['crafts'];
        return list.map((item) => GiProductModel.fromJson(item)).toList();
      }
    } catch (_) {}
    return [];
  }

  Future<List<Map<String, dynamic>>> getArtisanClusters() async {
    try {
      final clusters = await SupabaseService.getArtisanClusters();
      if (clusters.isNotEmpty) return clusters;
    } catch (_) {}
    return [];
  }

  Future<List<GiProductModel>> searchCrafts(String query) async {
    try {
      final supaCrafts = await SupabaseService.getProducts(search: query);
      if (supaCrafts.isNotEmpty) return supaCrafts;
    } catch (_) {}
    try {
      final response = await _dio.get('/crafts/search', queryParameters: {'q': query});
      if (response.statusCode == 200 && response.data['crafts'] != null) {
        final List list = response.data['crafts'];
        return list.map((item) => GiProductModel.fromJson(item)).toList();
      }
    } catch (_) {}
    return [];
  }
}
