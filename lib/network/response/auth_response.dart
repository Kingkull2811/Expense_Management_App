class AuthResponse {
  final String? accessToken;
  final String? refreshToken;
  final String? expiredAccessToken;


  AuthResponse({
     this.accessToken,
     this.refreshToken,
     this.expiredAccessToken,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      expiredAccessToken: json['expiredAccessDate'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['accessToken'] = accessToken;
    data['refreshToken'] = refreshToken;
    data['expiredAccessDate'] = expiredAccessToken;
    return data;
  }

  @override
  String toString() {
    return 'AuthResponse{accessToken: $accessToken, refreshToken: $refreshToken, tokenType: $expiredAccessToken}';
  }
}