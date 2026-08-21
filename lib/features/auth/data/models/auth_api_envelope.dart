
class AuthApiEnvelope {
  const AuthApiEnvelope({
    required this.status,
    required this.data,
    required this.errors,
    required this.code,
    required this.message,
  });

  factory AuthApiEnvelope.fromJson(Map<String, dynamic> json) {
    return AuthApiEnvelope(
      status: json['status'] as bool? ?? false,
      data: json['data'],
      errors: (json['errors'] as List?)?.cast<String>(),
      code: json['code'] as int?,
      message: json['message'] as String?,
    );
  }

  final bool status;
  final dynamic data;
  final List<String>? errors;
  final int? code;
  final String? message;

  /// `data` as a JSON object, or an empty map if it is absent/not an
  /// object (e.g. a 200 with a null payload).
  Map<String, dynamic> get dataAsMap =>
      data is Map<String, dynamic> ? data as Map<String, dynamic> : const {};

  /// `data` as a plain string (the shape `GuidApiResponse` uses for the
  /// newly created user's id).
  String get dataAsString => data is String ? data as String : '';
}
