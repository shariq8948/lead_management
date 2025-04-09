class ApiResponse<T> {
  final String status;
  final String message;
  final T? data;
  final String? error;

  ApiResponse({
    required this.status,
    required this.message,
    this.data,
    this.error,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      data: json['data'],
      error: json['error']?.toString(),
    );
  }

  bool get isSuccess => status == '1';
}
