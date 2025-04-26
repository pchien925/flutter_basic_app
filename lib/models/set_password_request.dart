class SetPasswordRequest {
  final String password;
  final String confirmPassword;

  SetPasswordRequest({required this.password, required this.confirmPassword});

  Map<String, dynamic> toJson() {
    return {'password': password, 'confirmPassword': confirmPassword};
  }
}
