class CommonListResponse<T> {
  String? message;
  List<T> data;

  CommonListResponse({this.message, this.data = const []});
}

class CommonStringResponse {
  String? message;

  CommonStringResponse({this.message});
}
