class ApiPath{
  static const String apiDomain = 'http://192.168.1.26:8080';
  static const String apiDomainMac = 'http://10.10.142.45:8080';

  static const String signup = '$apiDomain/api/auth/sign-up';

  static const String signIn = '$apiDomain/api/auth/sign-in';

  static const String changePassword = '$apiDomain/api/auth/change-password';

  static const String forgotPassword = '$apiDomain/api/auth/forgot-password';

  static const String newPassword = '$apiDomain/api/auth/new-password';

  static const String refreshToken = '$apiDomain/api/auth/refresh-token';

  static const String sendOtp = '$apiDomain/api/auth/send-otp';




}