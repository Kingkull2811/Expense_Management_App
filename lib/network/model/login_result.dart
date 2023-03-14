class LoginResult {
  final bool isSuccess;
  LoginError error;

  LoginResult({
    this.isSuccess =false,
    this.error = LoginError.unknown,
});
}

enum LoginError {
  incorrectLogin,
  internalServerError,
  emptyAuthorizationCode,
  unknown,
}
