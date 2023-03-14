class SignUpState {
  final String? email;

  SignUpState({this.email});
}

extension SignUpStateEx on SignUpState {
  SignUpState copyWith({
    String? email,
  }) =>
      SignUpState(
        email: email ?? this.email,
      );
}
