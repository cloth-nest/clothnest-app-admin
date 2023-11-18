class BaseResponse {
  dynamic data;
  int? statusCode;
  String? message;

  BaseResponse({
    this.data,
    this.statusCode,
    this.message,
  });

  BaseResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'];
  }
}
