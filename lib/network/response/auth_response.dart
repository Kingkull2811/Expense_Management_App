class AuthResponse {
  final String? accessToken;
  final String? refreshToken;
  final String? tokenType;

  AuthResponse({
     this.accessToken,
     this.refreshToken,
     this.tokenType,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      tokenType: json['tokenType'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['accessToken'] = accessToken;
    data['refreshToken'] = refreshToken;
    data['tokenType'] = tokenType;
    return data;
  }

  @override
  String toString() {
    return 'AuthResponse{accessToken: $accessToken, refreshToken: $refreshToken, tokenType: $tokenType}';
  }
}