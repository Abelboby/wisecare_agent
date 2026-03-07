/// Response payload for POST /auth/signin (flat body, no data wrapper).
class LoginResponseModel {
  const LoginResponseModel({
    required this.accessToken,
    this.refreshToken,
    this.userId,
    this.role,
    this.name,
    this.email,
    this.onboardingStep,
    this.profileComplete,
    this.city,
    this.inviteCode,
  });

  final String accessToken;
  final String? refreshToken;
  final String? userId;
  final String? role;
  final String? name;
  final String? email;
  final String? onboardingStep;
  final bool? profileComplete;
  final String? city;
  final String? inviteCode;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String?,
      userId: json['userId'] as String?,
      role: json['role'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      onboardingStep: json['onboardingStep'] as String?,
      profileComplete: json['profileComplete'] as bool?,
      city: json['city'] as String?,
      inviteCode: json['inviteCode'] as String?,
    );
  }
}
