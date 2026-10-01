import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/rfq_model.dart';

class B2bRfqNotifier extends StateNotifier<List<B2bRFQ>> {
  B2bRfqNotifier() : super(seededRFQs);

  void addRFQ(B2bRFQ rfq) {
    state = [rfq, ...state];
  }

  void updateStatus(String rfqId, String newStatus) {
    state = state.map((r) {
      if (r.id == rfqId) {
        return B2bRFQ(
          id: r.id,
          buyerName: r.buyerName,
          buyerType: r.buyerType,
          title: r.title,
          craftType: r.craftType,
          units: r.units,
          budget: r.budget,
          deadline: r.deadline,
          status: newStatus,
          location: r.location,
          notes: r.notes,
          isVerified: r.isVerified,
          image: r.image,
        );
      }
      return r;
    }).toList();
  }
}

final b2bRfqProvider = StateNotifierProvider<B2bRfqNotifier, List<B2bRFQ>>((ref) {
  return B2bRfqNotifier();
});
