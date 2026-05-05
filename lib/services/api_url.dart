class ApiUrl {
  static const String baseUrl = 'http://0.0.0.0:8000';

  // Privacy Policy Endpoints
  static const String getAllPrivacyPolicies =
      '$baseUrl/privacy-policies/get-all';
  static const String getPrivacyPolicyById = '$baseUrl/privacy-policies/get-by';
}
