class ApiResult<T> {
  final bool succeeded;
  final T result;
  final List<ApiResultError> errors;

  ApiResult({
    required this.succeeded,
    required this.result,
    required this.errors,
  });

  factory ApiResult.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return ApiResult(
      succeeded: json['succeeded'] as bool,
      result: fromJsonT(json['result']),
      errors: (json['errors'] as List<dynamic>)
          .map((e) => ApiResultError.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ApiResultError {
  final String code;
  final String message;

  ApiResultError({
    required this.code,
    required this.message,
  });

  factory ApiResultError.fromJson(Map<String, dynamic> json) {
    return ApiResultError(
      code: json['code'] as String,
      message: json['message'] as String,
    );
  }
}
