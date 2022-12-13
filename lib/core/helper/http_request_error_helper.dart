import 'dart:convert';
import 'package:http/http.dart';

Response httpRequestErrorHelper({
  required String httpMethod,
  required dynamic error,
  required String url,
}) {
  Map<String, dynamic> body = {
    'status': false,
    'message': '$url, e: $error',
    'error_message': '$url, e: $error',
  };

  int statusCode = 404;
  String bodyJson = jsonEncode(body);
  Uri address = Uri.parse(url);

  return Response(
    bodyJson,
    statusCode,
    request: Request(httpMethod, address),
  );
}
