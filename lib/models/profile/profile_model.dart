/// Response model for GET /users/me.
class ProfileModel {
  final String userId;
  final String email;
  final String name;
  final String role;
  final String phone;
  final String? profilePhotoUrl;
  final String? createdAt;
  final String? dateOfBirth;
  final int? age;
  final String? city;
  final String? cityImageUrl;
  final String? address;
  final String? gender;
  final String? bloodGroup;
  final List<EmergencyContact>? emergencyContacts;
  final List<String>? preExistingConditions;
  final bool profileComplete;
  final String onboardingStep;
  final ProfileSettings settings;

  ProfileModel({
    required this.userId,
    required this.email,
    required this.name,
    required this.role,
    required this.phone,
    this.profilePhotoUrl,
    this.createdAt,
    this.dateOfBirth,
    this.age,
    this.city,
    this.cityImageUrl,
    this.address,
    this.gender,
    this.bloodGroup,
    this.emergencyContacts,
    this.preExistingConditions,
    required this.profileComplete,
    required this.onboardingStep,
    required this.settings,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    List<EmergencyContact>? contacts;
    if (json['emergencyContacts'] != null &&
        json['emergencyContacts'] is List &&
        (json['emergencyContacts'] as List).isNotEmpty) {
      contacts = (json['emergencyContacts'] as List)
          .map((e) => EmergencyContact.fromJson(
              e is Map<String, dynamic> ? e : <String, dynamic>{}))
          .toList();
    } else if (json['emergencyContact'] != null &&
        json['emergencyContact'].toString().isNotEmpty) {
      contacts = [
        EmergencyContact(
          name: json['emergencyContactName'] as String? ?? '',
          phoneNumber: json['emergencyContact'] as String,
          relationship: json['emergencyContactRelationship'] as String? ?? '',
          isPrimary: true,
        ),
      ];
    }

    return ProfileModel(
      userId: json['userId'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      phone: json['phone'] as String,
      profilePhotoUrl: json['profilePhotoUrl'] as String?,
      createdAt: json['createdAt'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      age: json['age'] as int?,
      city: json['city'] as String?,
      cityImageUrl: json['cityImageUrl'] as String?,
      address: json['address'] as String?,
      gender: json['gender'] as String?,
      bloodGroup: json['bloodGroup'] as String?,
      emergencyContacts: contacts,
      preExistingConditions: json['preExistingConditions'] != null
          ? List<String>.from(json['preExistingConditions'] as List)
          : null,
      profileComplete: (json['profileComplete'] as bool?) ?? false,
      onboardingStep: (json['onboardingStep'] as String?) ?? 'BASIC_INFO',
      settings: ProfileSettings.fromJson(
        (json['settings'] as Map<String, dynamic>?) ?? {},
      ),
    );
  }

  /// Full JSON for cache persistence. Use with [ProfileModel.fromJson].
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'userId': userId,
      'email': email,
      'name': name,
      'role': role,
      'phone': phone,
      'profilePhotoUrl': profilePhotoUrl,
      'createdAt': createdAt,
      'dateOfBirth': dateOfBirth,
      'age': age,
      'city': city,
      'cityImageUrl': cityImageUrl,
      'address': address,
      'gender': gender,
      'bloodGroup': bloodGroup,
      'emergencyContacts': emergencyContacts?.map((e) => e.toJson()).toList(),
      'preExistingConditions': preExistingConditions,
      'profileComplete': profileComplete,
      'onboardingStep': onboardingStep,
      'settings': settings.toJson(),
    };
  }

  /// "Member since YYYY" derived from createdAt ISO timestamp.
  String get memberSince {
    if (createdAt == null) return '';
    try {
      return DateTime.parse(createdAt!).year.toString();
    } catch (_) {
      return '';
    }
  }

  /// Formatted age label, e.g. "68 Years".
  String get ageLabel {
    final years = age ?? _ageFromDateOfBirth(dateOfBirth);
    if (years != null) return '$years Years';
    return '';
  }

  static int? _ageFromDateOfBirth(String? dob) {
    if (dob == null || dob.isEmpty) return null;
    try {
      final birth = DateTime.parse(dob);
      final today = DateTime.now();
      int years = today.year - birth.year;
      if (today.month < birth.month ||
          (today.month == birth.month && today.day < birth.day)) {
        years--;
      }
      return years >= 0 ? years : null;
    } catch (_) {
      return null;
    }
  }

  /// Primary contact (isPrimary: true) or first in list.
  EmergencyContact? get primaryContact {
    if (emergencyContacts == null || emergencyContacts!.isEmpty) return null;
    try {
      return emergencyContacts!.firstWhere(
        (c) => c.isPrimary,
        orElse: () => emergencyContacts!.first,
      );
    } catch (_) {
      return emergencyContacts!.first;
    }
  }

  ProfileModel copyWith({
    String? userId,
    String? email,
    String? name,
    String? role,
    String? phone,
    String? profilePhotoUrl,
    String? createdAt,
    String? dateOfBirth,
    int? age,
    String? city,
    String? cityImageUrl,
    String? address,
    String? gender,
    String? bloodGroup,
    List<EmergencyContact>? emergencyContacts,
    List<String>? preExistingConditions,
    bool? profileComplete,
    String? onboardingStep,
    ProfileSettings? settings,
  }) {
    return ProfileModel(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      createdAt: createdAt ?? this.createdAt,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      age: age ?? this.age,
      city: city ?? this.city,
      cityImageUrl: cityImageUrl ?? this.cityImageUrl,
      address: address ?? this.address,
      gender: gender ?? this.gender,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      emergencyContacts: emergencyContacts ?? this.emergencyContacts,
      preExistingConditions:
          preExistingConditions ?? this.preExistingConditions,
      profileComplete: profileComplete ?? this.profileComplete,
      onboardingStep: onboardingStep ?? this.onboardingStep,
      settings: settings ?? this.settings,
    );
  }
}

/// Request body for PUT /users/me. Only non-null fields are sent.
class UpdateProfileRequest {
  UpdateProfileRequest({
    this.name,
    this.profilePhotoUrl,
    this.dateOfBirth,
    this.city,
    this.cityImageUrl,
    this.phone,
    this.address,
    this.gender,
    this.bloodGroup,
  });

  final String? name;
  final String? profilePhotoUrl;
  final String? dateOfBirth;
  final String? city;
  final String? cityImageUrl;
  final String? phone;
  final String? address;
  final String? gender;
  final String? bloodGroup;

  /// Only allowed fields for PUT /users/me per backend API.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (profilePhotoUrl != null) data['profilePhotoUrl'] = profilePhotoUrl;
    if (dateOfBirth != null) data['dateOfBirth'] = dateOfBirth;
    if (city != null) data['city'] = city;
    if (cityImageUrl != null) data['cityImageUrl'] = cityImageUrl;
    return data;
  }
}

class ProfileSettings {
  final bool notificationSoundsEnabled;
  final String fontSize;

  ProfileSettings({
    required this.notificationSoundsEnabled,
    required this.fontSize,
  });

  factory ProfileSettings.fromJson(Map<String, dynamic> json) {
    return ProfileSettings(
      notificationSoundsEnabled:
          (json['notificationSoundsEnabled'] as bool?) ?? true,
      fontSize: (json['fontSize'] as String?) ?? 'Medium',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationSoundsEnabled': notificationSoundsEnabled,
      'fontSize': fontSize,
    };
  }
}

/// One entry in the emergencyContacts array.
class EmergencyContact {
  final String name;
  final String phoneNumber;
  final String relationship;
  final bool isPrimary;

  EmergencyContact({
    required this.name,
    required this.phoneNumber,
    required this.relationship,
    this.isPrimary = false,
  });

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      name: (json['name'] as String?) ?? '',
      phoneNumber: (json['phoneNumber'] as String?) ?? '',
      relationship: (json['relationship'] as String?) ?? '',
      isPrimary: (json['isPrimary'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'relationship': relationship,
      'isPrimary': isPrimary,
    };
  }

  /// Two-letter initials derived from the contact name.
  String get initials {
    final n = name.trim();
    if (n.isEmpty) return '?';
    final parts = n.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return n[0].toUpperCase();
  }

  /// Formatted relationship label.
  String get relationshipLabel {
    if (relationship.trim().isNotEmpty) return relationship;
    return 'Emergency Contact';
  }
}
