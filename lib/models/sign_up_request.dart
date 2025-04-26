class SignUpRequest {
  final String fullName;
  final String email;
  final String phone;
  final String gender;
  final DateTime dob;
  final String? address;
  final String password;
  final String confirmPassword;

  SignUpRequest({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.gender,
    required this.dob,
    this.address,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'gender': gender,
      'dob': dob.toIso8601String(),
      'address': address,
      'password': password,
      'confirmPassword': confirmPassword,
    };
  }
}
