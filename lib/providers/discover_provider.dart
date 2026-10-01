import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/state_path_model.dart';
import '../models/festival_model.dart';
import '../services/data_repository.dart';
import '../repositories/festival_repository.dart';

final dataRepositoryProvider = Provider<DataRepository>((ref) {
  return DataRepository();
});

final statePathsFutureProvider = FutureProvider<List<StatePathModel>>((ref) async {
  final repo = ref.watch(dataRepositoryProvider);
  return await repo.loadStatePaths();
});

final festivalsFutureProvider = FutureProvider<List<FestivalModel>>((ref) async {
  return await FestivalRepository().getFestivals();
});

class DiscoverState {
  final String? selectedStateId;
  final String selectedRegion;
  final String searchQuery;
  final bool isMapZoomed;
  final double mapZoomScale;
  final List<StatePathModel> statePaths;
  final bool isLoading;

  const DiscoverState({
    this.selectedStateId,
    this.selectedRegion = 'All',
    this.searchQuery = '',
    this.isMapZoomed = false,
    this.mapZoomScale = 1.0,
    this.statePaths = const [],
    this.isLoading = false,
  });

  DiscoverState copyWith({
    String? selectedStateId,
    String? selectedRegion,
    String? searchQuery,
    bool? isMapZoomed,
    double? mapZoomScale,
    List<StatePathModel>? statePaths,
    bool? isLoading,
    bool clearSelectedState = false,
  }) {
    return DiscoverState(
      selectedStateId: clearSelectedState ? null : (selectedStateId ?? this.selectedStateId),
      selectedRegion: selectedRegion ?? this.selectedRegion,
      searchQuery: searchQuery ?? this.searchQuery,
      isMapZoomed: isMapZoomed ?? this.isMapZoomed,
      mapZoomScale: mapZoomScale ?? this.mapZoomScale,
      statePaths: statePaths ?? this.statePaths,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class DiscoverController extends StateNotifier<DiscoverState> {
  final DataRepository _repository;

  DiscoverController(this._repository) : super(const DiscoverState()) {
    init();
  }

  Future<void> init() async {
    state = state.copyWith(isLoading: true);
    final paths = await _repository.loadStatePaths();
    state = state.copyWith(statePaths: paths, isLoading: false);
  }

  void selectState(String? stateId) {
    if (state.selectedStateId == stateId) {
      state = state.copyWith(clearSelectedState: true);
    } else {
      state = state.copyWith(selectedStateId: stateId);
    }
  }

  void selectRegion(String region) {
    state = state.copyWith(
      selectedRegion: region,
      clearSelectedState: true,
    );
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setZoomScale(double scale) {
    state = state.copyWith(
      mapZoomScale: scale,
      isMapZoomed: scale > 1.2,
    );
  }

  void resetZoom() {
    state = state.copyWith(
      mapZoomScale: 1.0,
      isMapZoomed: false,
    );
  }
}

final discoverControllerProvider = StateNotifierProvider<DiscoverController, DiscoverState>((ref) {
  final repo = ref.watch(dataRepositoryProvider);
  return DiscoverController(repo);
});
