class SignInResult {
  final bool isSuccess;
  LoginError error;

  SignInResult({
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
