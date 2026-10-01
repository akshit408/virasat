enum UserRole { buyer, artisan, seller, admin }

class UserModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final UserRole role;
  final String? state;
  final String? district;
  final String? craftCategory;
  final String? avatarUrl;
  final String? preferredLanguage;
  final String? bio;
  final bool isVerifiedArtisan;
  final bool isGuest;
  final int totalProducts;
  final double rating;

  const UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.role,
    this.state,
    this.district,
    this.craftCategory,
    this.avatarUrl,
    this.preferredLanguage,
    this.bio,
    this.isVerifiedArtisan = false,
    this.isGuest = false,
    this.totalProducts = 0,
    this.rating = 4.8,
  });

  bool get isSeller => role == UserRole.artisan || role == UserRole.seller;
  bool get isAdmin => role == UserRole.admin;
  bool get isBuyer => role == UserRole.buyer;
  bool get isAuthenticated => id.isNotEmpty && !isGuest;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final roleStr = (json['role'] as String? ?? '').toLowerCase();
    UserRole parsedRole = UserRole.buyer;
    if (roleStr == 'admin') {
      parsedRole = UserRole.admin;
    } else if (roleStr == 'artisan' || roleStr == 'seller') {
      parsedRole = UserRole.artisan;
    }

    return UserModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      name: json['full_name'] as String? ?? json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: parsedRole,
      state: json['state'] as String?,
      district: json['district'] as String?,
      craftCategory: json['craftCategory'] as String? ?? json['craft_category'] as String?,
      avatarUrl: json['avatar_url'] as String? ?? json['avatarUrl'] as String?,
      preferredLanguage: json['preferredLanguage'] as String? ?? json['preferred_language'] as String?,
      bio: json['bio'] as String?,
      isVerifiedArtisan: json['isVerifiedArtisan'] as bool? ?? json['is_verified'] as bool? ?? false,
      isGuest: json['isGuest'] as bool? ?? false,
      totalProducts: json['totalProducts'] as int? ?? json['total_products'] as int? ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'role': role.name,
      'state': state,
      'district': district,
      'craftCategory': craftCategory,
      'avatarUrl': avatarUrl,
      'preferredLanguage': preferredLanguage,
      'bio': bio,
      'isVerifiedArtisan': isVerifiedArtisan,
      'isGuest': isGuest,
      'totalProducts': totalProducts,
      'rating': rating,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    UserRole? role,
    String? state,
    String? district,
    String? craftCategory,
    String? avatarUrl,
    String? preferredLanguage,
    String? bio,
    bool? isVerifiedArtisan,
    bool? isGuest,
    int? totalProducts,
    double? rating,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      role: role ?? this.role,
      state: state ?? this.state,
      district: district ?? this.district,
      craftCategory: craftCategory ?? this.craftCategory,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      bio: bio ?? this.bio,
      isVerifiedArtisan: isVerifiedArtisan ?? this.isVerifiedArtisan,
      isGuest: isGuest ?? this.isGuest,
      totalProducts: totalProducts ?? this.totalProducts,
      rating: rating ?? this.rating,
    );
  }
}
