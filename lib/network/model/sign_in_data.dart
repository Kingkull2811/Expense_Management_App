class SignInData {
  final String? accessToken;
  final String? refreshToken;
  final int? id;
  final String? username;
  final String? email;
  final String? roles;

  SignInData({
    this.accessToken,
    this.refreshToken,
    this.id,
    this.username,
    this.email,
    this.roles,
  });

  factory SignInData.fromJson(Map<String, dynamic> json) => SignInData(
        accessToken: json['accessToken'],
        refreshToken: json['refreshToken'],
        id: json['id'],
        username: json['username'],
        email: json['email'],
        roles: json['roles'],
      );

  @override
  String toString() {
    return 'SignInModel{accessToken: $accessToken, refreshToken: $refreshToken, id: $id, username: $username, email: $email, roles: $roles}';
  }
}
