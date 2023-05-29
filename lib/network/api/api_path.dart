class ApiPath {
  static const String apiDomain = 'http://192.168.1.26:8080';
  // static const String apiDomain = 'http://159.223.40.101:8081';
  // static const String apiDomainMac = 'http://10.10.142.45:8080';

  static const String signup = '$apiDomain/api/auth/sign-up';

  static const String signIn = '$apiDomain/api/auth/sign-in';

  static const String changePassword = '$apiDomain/api/auth/change-password';

  static const String forgotPassword = '$apiDomain/api/auth/forgot-password';

  static const String newPassword = '$apiDomain/api/auth/new-password';

  static const String refreshToken = '$apiDomain/api/auth/refresh-token';

  static const String sendOtp = '$apiDomain/api/auth/send-otp';

  static const String getAllListCategory = '$apiDomain/api/v1/category/all';

  static const String apiCategory = '$apiDomain/api/v1/category';

  static const String apiLogoCategory = '$apiDomain/api/v1/category-logo';

  static const String getListWallet = '$apiDomain/api/v1/wallet';

  static const String transaction = '$apiDomain/api/v1/transaction';

  static const String getReportByWalletId = '$apiDomain/api/v1/report/';

  static const String expenseLimit = '$apiDomain/api/v1/expense-limit';

  static const String recurring = '$apiDomain/api/v1/recurring-transaction';

  static const String exportData = '$apiDomain/api/v1/export';
}
