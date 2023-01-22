import 'dart:convert';

class Token {
  final String access_token;
  final String token_type;
  final int expires_in;

  Token({required this.access_token, required this.token_type, required this.expires_in});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      access_token: json['access_token'],
      token_type: json['token_type'],
      expires_in: json['expires_in'],
    );
  }
}
