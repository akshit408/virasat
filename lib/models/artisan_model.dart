class ArtisanModel {
  final String id;
  final String name;
  final String gender;
  final String stateId;
  final String village;
  final String craftId;
  final int experienceYears;
  final List<String> languages;
  final String bio;
  final bool verified;
  final double rating;
  final String profileImage;

  const ArtisanModel({
    required this.id,
    required this.name,
    required this.gender,
    required this.stateId,
    required this.village,
    required this.craftId,
    required this.experienceYears,
    required this.languages,
    required this.bio,
    this.verified = true,
    this.rating = 4.8,
    required this.profileImage,
  });

  factory ArtisanModel.fromJson(Map<String, dynamic> json) {
    final nameVal = json['artisanName'] as String? ?? json['name'] as String? ?? '';
    final avatar = json['avatarImage'] as String? ?? json['profileImage'] as String? ?? json['bannerImage'] as String? ?? '';
    final isVer = json['verificationStatus'] == 'verified' || (json['verified'] as bool? ?? true);

    return ArtisanModel(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      name: nameVal.isNotEmpty ? nameVal : 'Master Artisan',
      gender: json['gender'] as String? ?? 'Master Craftsman',
      stateId: json['stateId'] as String? ?? json['state'] as String? ?? '',
      village: json['village'] as String? ?? json['district'] as String? ?? '',
      craftId: json['craftId'] as String? ?? json['craftSpecialization'] as String? ?? '',
      experienceYears: (json['experienceYears'] as num?)?.toInt() ?? (json['yearsExperience'] as num?)?.toInt() ?? 15,
      languages: (json['languages'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const ['Hindi', 'English'],
      bio: json['bio'] as String? ?? '',
      verified: isVer,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
      profileImage: avatar.isNotEmpty ? avatar : 'assets/images/crafts/bandhani_01.jpg',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'stateId': stateId,
      'village': village,
      'craftId': craftId,
      'experienceYears': experienceYears,
      'languages': languages,
      'bio': bio,
      'verified': verified,
      'rating': rating,
      'profileImage': profileImage,
    };
  }

  ArtisanModel copyWith({
    String? id,
    String? name,
    String? gender,
    String? stateId,
    String? village,
    String? craftId,
    int? experienceYears,
    List<String>? languages,
    String? bio,
    bool? verified,
    double? rating,
    String? profileImage,
  }) {
    return ArtisanModel(
      id: id ?? this.id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      stateId: stateId ?? this.stateId,
      village: village ?? this.village,
      craftId: craftId ?? this.craftId,
      experienceYears: experienceYears ?? this.experienceYears,
      languages: languages ?? this.languages,
      bio: bio ?? this.bio,
      verified: verified ?? this.verified,
      rating: rating ?? this.rating,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}
