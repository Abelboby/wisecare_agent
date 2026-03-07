/// App config, API, UI constants, common strings.
class StaticValues {
  StaticValues._();

  static const String appName = 'WiseAgent';
  static const String apiBaseUrl = 'https://3fl3pytece.execute-api.ap-south-1.amazonaws.com/prod';
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  static const double defaultPadding = 16.0;
  static const double defaultRadius = 8.0;
  static const double defaultDurationMs = 300.0;

  static const String loadingMessage = 'Loading...';
  static const String errorMessage = 'Something went wrong.';
  static const String successMessage = 'Success';
  static const String validationErrorMessage = 'Please check your input.';
}
