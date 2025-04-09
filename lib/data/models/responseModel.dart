class ResponseModel {
  final bool success;
  final String message;

  ResponseModel({required this.success, required this.message});

  // Factory method to create a ResponseModel from the response body
  factory ResponseModel.fromResponse(String responseBody) {
    // Check for specific responses to determine success
    if (responseBody.contains('Successfully')) {
      return ResponseModel(success: true, message: responseBody);
    } else {
      return ResponseModel(success: false, message: responseBody);
    }
  }
}
