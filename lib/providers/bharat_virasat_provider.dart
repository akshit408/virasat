import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/state_model.dart';
import '../models/gi_product_model.dart';
import '../services/craft_service.dart';
import '../services/data_repository.dart';

final craftServiceProvider = Provider<CraftService>((ref) => CraftService());

final statesProvider = FutureProvider<List<StateModel>>((ref) async {
  return DataRepository().loadStates();
});

final stateDetailProvider = FutureProvider.family<StateModel, String>((ref, stateId) async {
  final states = await DataRepository().loadStates();
  return states.firstWhere(
    (state) => state.id == stateId || state.name.toLowerCase() == stateId.toLowerCase(),
    orElse: () => states.isNotEmpty ? states.first : throw StateError('No state data available'),
  );
});

final craftsProvider = FutureProvider<List<GiProductModel>>((ref) async {
  return ref.watch(craftServiceProvider).getAllCrafts();
});

final craftDetailProvider = FutureProvider.family<GiProductModel, String>((ref, craftId) async {
  return ref.watch(craftServiceProvider).getCraftById(craftId);
});
