class ApiUrl {
  static const String baseUrl = 'http://127.0.0.1:8000';

  // Privacy Policy Endpoints
  static const String getAllPrivacyPolicies = '$baseUrl/privacy-policies/get-all';
  static const String getPrivacyPolicyById = '$baseUrl/privacy-policies/get-by';

  // Terms and Conditions Endpoints
  static const String getAllTermsConditions = '$baseUrl/terms-conditions/get-all';
  static const String getTermsConditionsById = '$baseUrl/terms-conditions/get-by';

  // Admin User Auth & Profile Endpoints
  static const String adminLogin = '$baseUrl/admin-users/login';
  static const String getAdminById = '$baseUrl/admin-users/get-by';
  static const String updateAdminById = '$baseUrl/admin-users/update-by';

  // Visual Ads Endpoints
  static const String createVisualAd = '$baseUrl/visual-ads/create';
  static const String getAllVisualAds = '$baseUrl/visual-ads/get-all';
  static const String updateVisualAd = '$baseUrl/visual-ads/update-by';
  static const String deleteVisualAd = '$baseUrl/visual-ads/delete-by';
}
