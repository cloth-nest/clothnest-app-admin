// dùng để khai báo các method của http (CRUD)
abstract class BaseApiServices {
  Future<dynamic> patch(String url, dynamic data, Map<String, String> headers);
  Future<dynamic> post(String url, dynamic data, Map<String, String> headers);
  Future<dynamic> get(String url, Map<String, String> headers);
  Future<dynamic> delete(String url, dynamic data, Map<String, String> headers);
  Future<dynamic> put(String url, dynamic data, Map<String, String> headers);
}
