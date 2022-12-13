import 'package:http/http.dart' as http;
import '../core.dart';

abstract class HttpRequestHelper {
  Future<http.Response> getRequest({
    required String url,
    required Map<String, String> headers,
  });
}

class HttpRequestHelperImpl implements HttpRequestHelper {
  final http.Client client;

  HttpRequestHelperImpl({
    required this.client,
  });

  @override
  Future<http.Response> getRequest({
    required String url,
    required Map<String, String> headers,
  }) async {
    Uri address = Uri.parse(url);

    try {
      return await client.get(address, headers: headers).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          return httpRequestErrorHelper(httpMethod: 'GET', error: 'Request Time Out', url: url);
        },
      );
    } catch (e) {
      return httpRequestErrorHelper(httpMethod: 'GET', error: e, url: url);
    }
  }
}
