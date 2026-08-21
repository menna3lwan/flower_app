import 'dart:convert';

abstract final class JwtPayloadDecoder {
  const JwtPayloadDecoder._();

  static Map<String, dynamic>? decode(String token) {
    final segments = token.split('.');
    if (segments.length != 3) return null;

    try {
      final normalized = base64Url.normalize(segments[1]);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final json = jsonDecode(decoded);
      return json is Map<String, dynamic> ? json : null;
    } on FormatException {
      return null;
    }
  }
}
