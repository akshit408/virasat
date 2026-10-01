import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/state_model.dart';
import '../models/gi_product_model.dart';
import '../models/festival_model.dart';
import '../models/spotlight_model.dart';
import '../models/state_path_model.dart';
import '../models/category_model.dart';
import '../models/artisan_model.dart';
import '../models/story_model.dart';
import '../models/discover_section_model.dart';
import '../models/home_banner_model.dart';
import '../models/ai_prompt_model.dart';
import '../models/assets_manifest_model.dart';
import '../repositories/discover_repository.dart';
import '../repositories/artisan_repository.dart';
import '../repositories/festival_repository.dart';

import '../services/supabase_service.dart';

class DataRepository {
  List<StateModel>? _cachedStates;
  List<GiProductModel>? _cachedCrafts;
  List<GiProductModel>? _cachedGiProducts;
  List<FestivalModel>? _cachedFestivals;
  List<SpotlightModel>? _cachedSpotlights;
  List<StatePathModel>? _cachedStatePaths;
  List<CategoryModel>? _cachedCategories;
  List<ArtisanModel>? _cachedArtisans;
  List<StoryModel>? _cachedStories;
  List<DiscoverSectionModel>? _cachedDiscoverSections;
  List<HomeBannerModel>? _cachedHomeBanners;
  List<AiPromptModel>? _cachedAiPrompts;
  AssetsManifestModel? _cachedAssetsManifest;

  Future<List<StateModel>> loadStates() async {
    if (_cachedStates != null) return _cachedStates!;
    try {
      final supaStates = await SupabaseService.getDiscoverStates();
      if (supaStates.isNotEmpty) {
        _cachedStates = supaStates;
        return _cachedStates!;
      }
    } catch (_) {}
    try {
      final apiStates = await DiscoverRepository().getStates();
      if (apiStates.isNotEmpty) {
        _cachedStates = apiStates;
        return _cachedStates!;
      }
    } catch (_) {}
    return [];
  }

  Future<List<GiProductModel>> loadCrafts() async {
    if (_cachedCrafts != null) return _cachedCrafts!;
    try {
      final supaCrafts = await SupabaseService.getCrafts();
      if (supaCrafts.isNotEmpty) {
        _cachedCrafts = supaCrafts;
        return _cachedCrafts!;
      }
    } catch (_) {}
    try {
      final apiCrafts = await DiscoverRepository().getCrafts();
      if (apiCrafts.isNotEmpty) {
        _cachedCrafts = apiCrafts;
        return _cachedCrafts!;
      }
    } catch (_) {}
    return [];
  }

  Future<List<GiProductModel>> loadGiProducts() async {
    if (_cachedGiProducts != null) return _cachedGiProducts!;
    try {
      final supaProducts = await SupabaseService.getProducts();
      if (supaProducts.isNotEmpty) {
        _cachedGiProducts = supaProducts;
        return _cachedGiProducts!;
      }
    } catch (_) {}
    return [];
  }

  Future<List<FestivalModel>> loadFestivals() async {
    if (_cachedFestivals != null) return _cachedFestivals!;
    try {
      final apiFestivals = await FestivalRepository().getFestivals();
      if (apiFestivals.isNotEmpty) {
        _cachedFestivals = apiFestivals;
        return _cachedFestivals!;
      }
    } catch (_) {}
    try {
      final jsonString = await rootBundle.loadString('assets/data/festivals.json');
      final List<dynamic> list = jsonDecode(jsonString);
      _cachedFestivals = list.map((item) => FestivalModel.fromJson(item as Map<String, dynamic>)).toList();
      return _cachedFestivals!;
    } catch (_) {
      return [];
    }
  }

  Future<List<SpotlightModel>> loadSpotlights() async {
    if (_cachedSpotlights != null) return _cachedSpotlights!;
    try {
      final jsonString = await rootBundle.loadString('assets/data/spotlight.json');
      final List<dynamic> list = jsonDecode(jsonString);
      _cachedSpotlights = list.map((item) => SpotlightModel.fromJson(item as Map<String, dynamic>)).toList();
      return _cachedSpotlights!;
    } catch (_) {
      return [];
    }
  }

  Future<List<StatePathModel>> loadStatePaths() async {
    if (_cachedStatePaths != null) return _cachedStatePaths!;
    try {
      final jsonString = await rootBundle.loadString('assets/maps/state_paths.json');
      final List<dynamic> list = jsonDecode(jsonString);
      _cachedStatePaths = list.map((item) => StatePathModel.fromJson(item as Map<String, dynamic>)).toList();
      return _cachedStatePaths!;
    } catch (_) {
      return [];
    }
  }

  Future<List<CategoryModel>> loadCategories() async {
    if (_cachedCategories != null) return _cachedCategories!;
    try {
      final jsonString = await rootBundle.loadString('assets/data/categories.json');
      final List<dynamic> list = jsonDecode(jsonString);
      _cachedCategories = list.map((item) => CategoryModel.fromJson(item as Map<String, dynamic>)).toList();
      return _cachedCategories!;
    } catch (_) {
      return [];
    }
  }

  Future<List<ArtisanModel>> loadArtisans() async {
    if (_cachedArtisans != null) return _cachedArtisans!;
    try {
      final supaArtisans = await SupabaseService.getArtisans();
      if (supaArtisans.isNotEmpty) {
        _cachedArtisans = supaArtisans;
        return _cachedArtisans!;
      }
    } catch (_) {}
    try {
      final apiArtisans = await ArtisanRepository().getArtisans();
      if (apiArtisans.isNotEmpty) {
        _cachedArtisans = apiArtisans;
        return _cachedArtisans!;
      }
    } catch (_) {}
    return [];
  }

  Future<List<StoryModel>> loadStories() async {
    if (_cachedStories != null) return _cachedStories!;
    try {
      final jsonString = await rootBundle.loadString('assets/data/stories.json');
      final List<dynamic> list = jsonDecode(jsonString);
      _cachedStories = list.map((item) => StoryModel.fromJson(item as Map<String, dynamic>)).toList();
      return _cachedStories!;
    } catch (_) {
      return [];
    }
  }

  Future<List<DiscoverSectionModel>> loadDiscoverSections() async {
    if (_cachedDiscoverSections != null) return _cachedDiscoverSections!;
    try {
      final jsonString = await rootBundle.loadString('assets/data/discover_sections.json');
      final List<dynamic> list = jsonDecode(jsonString);
      _cachedDiscoverSections = list.map((item) => DiscoverSectionModel.fromJson(item as Map<String, dynamic>)).toList();
      return _cachedDiscoverSections!;
    } catch (_) {
      return [];
    }
  }

  Future<List<HomeBannerModel>> loadHomeBanners() async {
    if (_cachedHomeBanners != null) return _cachedHomeBanners!;
    try {
      final jsonString = await rootBundle.loadString('assets/data/home_banner.json');
      final List<dynamic> list = jsonDecode(jsonString);
      _cachedHomeBanners = list.map((item) => HomeBannerModel.fromJson(item as Map<String, dynamic>)).toList();
      return _cachedHomeBanners!;
    } catch (_) {
      return [];
    }
  }

  Future<List<AiPromptModel>> loadAiPrompts() async {
    if (_cachedAiPrompts != null) return _cachedAiPrompts!;
    try {
      final jsonString = await rootBundle.loadString('assets/data/ai_prompts.json');
      final List<dynamic> list = jsonDecode(jsonString);
      _cachedAiPrompts = list.map((item) => AiPromptModel.fromJson(item as Map<String, dynamic>)).toList();
      return _cachedAiPrompts!;
    } catch (_) {
      return [];
    }
  }

  Future<AssetsManifestModel?> loadAssetsManifest() async {
    if (_cachedAssetsManifest != null) return _cachedAssetsManifest!;
    try {
      final jsonString = await rootBundle.loadString('assets/data/assets_manifest.json');
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      _cachedAssetsManifest = AssetsManifestModel.fromJson(jsonMap);
      return _cachedAssetsManifest;
    } catch (_) {
      return null;
    }
  }
}

