/// API path constants.
class Endpoints {
  Endpoints._();

  // ── Auth (no token required) ──────────────────────────────────────────────
  static const String authSignup = '/auth/signup';
  static const String authSignin = '/auth/signin';
  static const String authRefresh = '/auth/refresh';
  static const String authSignout = '/auth/signout';

  // ── User ──────────────────────────────────────────────────────────────────
  static const String usersMe = '/users/me';
  static const String usersMeSettings = '/users/me/settings';
  static const String usersMeEmergencyContact = '/users/me/emergency-contact';
  static const String uploads = '/uploads';

  // ── Service Requests ──────────────────────────────────────────────────────
  static const String serviceRequests = '/service-requests';
  static String serviceRequest(String requestId) => '/service-requests/$requestId';
  static String serviceRequestStatus(String requestId) => '/service-requests/$requestId/status';
  static String serviceRequestAssign(String requestId) => '/service-requests/$requestId/assign';

  // ── Notifications ─────────────────────────────────────────────────────────
  static const String notificationsRegister = '/notifications/register';

  // ── Admin ─────────────────────────────────────────────────────────────────
  static const String adminStats = '/admin/stats';
  static const String adminAlerts = '/admin/alerts';
  static const String adminUsers = '/admin/users';
  static String adminUser(String userId) => '/admin/users/$userId';
  static const String adminCreateAgent = '/admin/users/agent';
  static String adminUserStatus(String userId) => '/admin/users/$userId/status';
  static const String adminAgentsAvailable = '/admin/agents/available';
}
