enum VerificationStatus { pending, verified, rejected }

class SellerVerificationModel {
  final String id;
  final String userId;
  final String fullName;
  final String phone;
  final String state;
  final String district;
  final String craftType;
  final String aadhaarNumber;
  final String aadhaarFrontUrl;
  final String aadhaarBackUrl;
  final String selfieUrl;
  final VerificationStatus status;
  final String? rejectionReason;
  final DateTime submittedAt;

  const SellerVerificationModel({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.phone,
    required this.state,
    required this.district,
    required this.craftType,
    required this.aadhaarNumber,
    this.aadhaarFrontUrl = '',
    this.aadhaarBackUrl = '',
    this.selfieUrl = '',
    this.status = VerificationStatus.pending,
    this.rejectionReason,
    required this.submittedAt,
  });

  factory SellerVerificationModel.fromJson(Map<String, dynamic> json) {
    VerificationStatus parseStatus(String? statusStr) {
      switch ((statusStr ?? '').toLowerCase()) {
        case 'verified':
          return VerificationStatus.verified;
        case 'rejected':
          return VerificationStatus.rejected;
        default:
          return VerificationStatus.pending;
      }
    }

    return SellerVerificationModel(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      state: json['state'] as String? ?? '',
      district: json['district'] as String? ?? '',
      craftType: json['craftType'] as String? ?? '',
      aadhaarNumber: json['aadhaarNumber'] as String? ?? '',
      aadhaarFrontUrl: json['aadhaarFrontUrl'] as String? ?? '',
      aadhaarBackUrl: json['aadhaarBackUrl'] as String? ?? '',
      selfieUrl: json['selfieUrl'] as String? ?? '',
      status: parseStatus(json['status'] as String?),
      rejectionReason: json['rejectionReason'] as String?,
      submittedAt: json['submittedAt'] != null
          ? DateTime.parse(json['submittedAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'fullName': fullName,
      'phone': phone,
      'state': state,
      'district': district,
      'craftType': craftType,
      'aadhaarNumber': aadhaarNumber,
      'aadhaarFrontUrl': aadhaarFrontUrl,
      'aadhaarBackUrl': aadhaarBackUrl,
      'selfieUrl': selfieUrl,
      'status': status.name,
      'rejectionReason': rejectionReason,
      'submittedAt': submittedAt.toIso8601String(),
    };
  }

  SellerVerificationModel copyWith({
    String? id,
    String? userId,
    String? fullName,
    String? phone,
    String? state,
    String? district,
    String? craftType,
    String? aadhaarNumber,
    String? aadhaarFrontUrl,
    String? aadhaarBackUrl,
    String? selfieUrl,
    VerificationStatus? status,
    String? rejectionReason,
    DateTime? submittedAt,
  }) {
    return SellerVerificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      state: state ?? this.state,
      district: district ?? this.district,
      craftType: craftType ?? this.craftType,
      aadhaarNumber: aadhaarNumber ?? this.aadhaarNumber,
      aadhaarFrontUrl: aadhaarFrontUrl ?? this.aadhaarFrontUrl,
      aadhaarBackUrl: aadhaarBackUrl ?? this.aadhaarBackUrl,
      selfieUrl: selfieUrl ?? this.selfieUrl,
      status: status ?? this.status,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      submittedAt: submittedAt ?? this.submittedAt,
    );
  }
}
