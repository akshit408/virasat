import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/government_scheme_model.dart';
import '../models/ngo_partner_model.dart';
import '../models/smart_notification_model.dart';
import '../models/training_centre_model.dart';
import '../models/workshop_event_model.dart';

enum ConnectTabMode {
  artisans,
  workshops,
  ngos,
  schemes,
  trainingCentres,
}

class VirasatConnectState {
  final ConnectTabMode selectedTab;
  final List<WorkshopEvent> workshops;
  final List<GovernmentScheme> schemes;
  final List<NGOPartner> ngos;
  final List<TrainingCentre> trainingCentres;
  final List<SmartNotificationModel> notifications;
  final Set<String> registeredWorkshopIds;
  final String searchQuery;
  final String selectedCategory;
  final bool isLoading;

  const VirasatConnectState({
    this.selectedTab = ConnectTabMode.artisans,
    this.workshops = const [],
    this.schemes = const [],
    this.ngos = const [],
    this.trainingCentres = const [],
    this.notifications = const [],
    this.registeredWorkshopIds = const {},
    this.searchQuery = '',
    this.selectedCategory = 'All',
    this.isLoading = false,
  });

  int get unreadNotificationsCount => notifications.where((n) => !n.isRead).length;

  List<WorkshopEvent> get filteredWorkshops {
    return workshops.where((w) {
      final matchesSearch = searchQuery.isEmpty ||
          w.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          w.location.toLowerCase().contains(searchQuery.toLowerCase()) ||
          w.craftCategory.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesCategory = selectedCategory == 'All' || w.craftCategory == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  List<GovernmentScheme> get filteredSchemes {
    return schemes.where((s) {
      final matchesSearch = searchQuery.isEmpty ||
          s.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          s.category.toLowerCase().contains(searchQuery.toLowerCase()) ||
          s.ministry.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesSearch;
    }).toList();
  }

  List<NGOPartner> get filteredNGOs {
    return ngos.where((n) {
      final matchesSearch = searchQuery.isEmpty ||
          n.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          n.location.toLowerCase().contains(searchQuery.toLowerCase()) ||
          n.focusArea.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesSearch;
    }).toList();
  }

  List<TrainingCentre> get filteredTrainingCentres {
    return trainingCentres.where((t) {
      final matchesSearch = searchQuery.isEmpty ||
          t.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          t.address.toLowerCase().contains(searchQuery.toLowerCase()) ||
          t.craftSpecialization.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesSearch;
    }).toList();
  }

  VirasatConnectState copyWith({
    ConnectTabMode? selectedTab,
    List<WorkshopEvent>? workshops,
    List<GovernmentScheme>? schemes,
    List<NGOPartner>? ngos,
    List<TrainingCentre>? trainingCentres,
    List<SmartNotificationModel>? notifications,
    Set<String>? registeredWorkshopIds,
    String? searchQuery,
    String? selectedCategory,
    bool? isLoading,
  }) {
    return VirasatConnectState(
      selectedTab: selectedTab ?? this.selectedTab,
      workshops: workshops ?? this.workshops,
      schemes: schemes ?? this.schemes,
      ngos: ngos ?? this.ngos,
      trainingCentres: trainingCentres ?? this.trainingCentres,
      notifications: notifications ?? this.notifications,
      registeredWorkshopIds: registeredWorkshopIds ?? this.registeredWorkshopIds,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class VirasatConnectNotifier extends StateNotifier<VirasatConnectState> {
  VirasatConnectNotifier() : super(const VirasatConnectState()) {
    loadData();
  }

  Future<void> loadData() async {
    state = state.copyWith(isLoading: true);
    try {
      final jsonStr = await rootBundle.loadString('assets/data/virasat_connect_data.json');
      final data = json.decode(jsonStr) as Map<String, dynamic>;

      final workshops = (data['workshops'] as List<dynamic>?)
              ?.map((e) => WorkshopEvent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [];

      final schemes = (data['schemes'] as List<dynamic>?)
              ?.map((e) => GovernmentScheme.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [];

      final ngos = (data['ngos'] as List<dynamic>?)
              ?.map((e) => NGOPartner.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [];

      final trainingCentres = (data['trainingCentres'] as List<dynamic>?)
              ?.map((e) => TrainingCentre.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [];

      // Initial Smart Notifications
      final initialNotifications = [
        SmartNotificationModel(
          id: 'notif_01',
          title: 'GI Registration Camp in Kutch',
          body: 'Free official GI Pehchan Card registration camp starting in Jamnagar & Ajrakhpur.',
          type: NotificationType.giCamp,
          targetId: 'sch_gi_pehchan',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          location: 'Jamnagar, Gujarat',
          craftCategory: 'Bandhani',
        ),
        SmartNotificationModel(
          id: 'notif_02',
          title: 'PM Vishwakarma Toolkit Grant Deadline',
          body: 'Apply for ₹15,000 free toolkit grant & 5% concessional credit before Dec 31.',
          type: NotificationType.scheme,
          targetId: 'sch_pm_vishwakarma',
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
          location: 'All India',
          craftCategory: 'All Crafts',
        ),
        SmartNotificationModel(
          id: 'notif_03',
          title: 'Seats Available: Natural Indigo Masterclass',
          body: '8 seats remaining for the 5-day Bandhani masterclass in Jamnagar.',
          type: NotificationType.workshop,
          targetId: 'ws_bandhani_01',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          location: 'Jamnagar, Gujarat',
          craftCategory: 'Bandhani',
        ),
      ];

      state = state.copyWith(
        workshops: workshops,
        schemes: schemes,
        ngos: ngos,
        trainingCentres: trainingCentres,
        notifications: initialNotifications,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  void selectTab(ConnectTabMode tab) {
    state = state.copyWith(selectedTab: tab);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setCategoryFilter(String category) {
    state = state.copyWith(selectedCategory: category);
  }

  bool registerForWorkshop(String workshopId) {
    final updatedWorkshops = state.workshops.map((w) {
      if (w.id == workshopId) {
        final newSeats = (w.availableSeats > 0) ? w.availableSeats - 1 : 0;
        return w.copyWith(isRegistered: true, availableSeats: newSeats);
      }
      return w;
    }).toList();

    final updatedSet = Set<String>.from(state.registeredWorkshopIds)..add(workshopId);

    state = state.copyWith(
      workshops: updatedWorkshops,
      registeredWorkshopIds: updatedSet,
    );

    return true;
  }

  void markNotificationAsRead(String notificationId) {
    final updated = state.notifications.map((n) {
      if (n.id == notificationId) {
        return n.copyWith(isRead: true);
      }
      return n;
    }).toList();

    state = state.copyWith(notifications: updated);
  }

  void triggerSmartNotificationsForArtisan({
    required String artisanLocation,
    required String craftCategory,
  }) {
    final newNotif = SmartNotificationModel(
      id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Opportunity Matched for $craftCategory',
      body: 'New workshop & government scheme subsidy matched for $artisanLocation artisans!',
      type: NotificationType.workshop,
      targetId: 'ws_bandhani_01',
      timestamp: DateTime.now(),
      location: artisanLocation,
      craftCategory: craftCategory,
    );

    state = state.copyWith(
      notifications: [newNotif, ...state.notifications],
    );
  }
}

final virasatConnectProvider = StateNotifierProvider<VirasatConnectNotifier, VirasatConnectState>((ref) {
  return VirasatConnectNotifier();
});
