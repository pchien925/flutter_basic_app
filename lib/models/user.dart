class User {
  final int? id;
  final String? fullName;
  final String email;
  final String? phone;
  final DateTime? dob;
  final String? avatar;
  final String? gender;
  final String? address;
  final String? status;
  final int? loyaltyPointsBalance;
  final String? token;

  User({
    this.id,
    this.fullName,
    required this.email,
    this.phone,
    this.dob,
    this.avatar,
    this.gender,
    this.address,
    this.status,
    this.loyaltyPointsBalance,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      phone: json['phone'],
      dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
      avatar: json['avatar'],
      gender: json['gender'],
      address: json['address'],
      status: json['status'],
      loyaltyPointsBalance: json['loyaltyPointsBalance'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'dob': dob?.toIso8601String(),
      'avatar': avatar,
      'gender': gender,
      'address': address,
      'status': status,
      'loyaltyPointsBalance': loyaltyPointsBalance,
      'token': token,
    };
  }
}
