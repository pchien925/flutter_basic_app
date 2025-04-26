class TokenResponse {
  final String accessToken;
  final String refreshToken;
  final int userId;

  TokenResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
  });

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      userId: json['userId'],
    );
  }
}
