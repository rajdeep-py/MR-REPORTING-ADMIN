class ApiUrl {
  static const String baseUrl = 'http://127.0.0.1:8000';

  // Privacy Policy Endpoints
  static const String getAllPrivacyPolicies = '$baseUrl/privacy-policies/get-all';
  static const String getPrivacyPolicyById = '$baseUrl/privacy-policies/get-by';

  // Terms and Conditions Endpoints
  static const String getAllTermsConditions = '$baseUrl/terms-conditions/get-all';
  static const String getTermsConditionsById = '$baseUrl/terms-conditions/get-by';
}
