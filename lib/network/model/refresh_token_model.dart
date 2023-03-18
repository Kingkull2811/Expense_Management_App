class RefreshTokenModel {
  final String? accessToken;
  final String? refreshToken;
  final String? tokenType;


  RefreshTokenModel({this.accessToken, this.refreshToken, this.tokenType,});

  factory RefreshTokenModel.fromJson(Map<String, dynamic> json) =>RefreshTokenModel(
    accessToken: json["accessToken"],
    refreshToken: json["refreshToken"],
    tokenType: json["tokenType"],
  );

  @override
  String toString() {
    return 'RefreshTokenModel{accessToken: $accessToken, refreshToken: $refreshToken, tokenType: $tokenType}';
  }
}