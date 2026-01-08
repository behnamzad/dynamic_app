import 'dart:convert';

class EncryptedRequest {
  final String encBody;

  EncryptedRequest({
    required this.encBody,
  });

  factory EncryptedRequest.fromRawJson(String str) => EncryptedRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EncryptedRequest.fromJson(Map<String, dynamic> json) => EncryptedRequest(
        encBody: json['encBody'],
      );

  Map<String, dynamic> toJson() => {
        'encBody': encBody,
      };

  String toStringJson() => json.encode(toJson());
}
