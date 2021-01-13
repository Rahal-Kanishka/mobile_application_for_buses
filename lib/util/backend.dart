import 'dart:convert';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

class BackEndResult {
  final int statusCode;
  final dynamic responseBody;

  const BackEndResult(this.statusCode, this.responseBody);
}

class BackEnd {

  static Future<BackEndResult> postRequest(
      Map<String, dynamic> dataObject, String requestPath) async {
    var json = await GlobalConfiguration()
        .loadFromPath('assets/cfg/configurations.json');
    var endPoint = GlobalConfiguration().getValue("backend_url");
    var url = endPoint + requestPath;

    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(dataObject));
    return new BackEndResult(response.statusCode, jsonDecode(response.body));
  }
}
