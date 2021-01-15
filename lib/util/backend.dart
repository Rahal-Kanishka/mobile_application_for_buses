import 'dart:convert';

import 'package:flutter_with_maps/common/user_session.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

class BackEndResult {
  final int statusCode;
  final dynamic responseBody;

  const BackEndResult(this.statusCode, this.responseBody);
}

class BackEnd {

  static Map<String,String> generateHeaders(){
    // get current token from the current session
    var token = UserSession().jwtToken;
    Map<String, String> headers = new Map();

    headers['Content-Type'] = 'application/json; charset=UTF-8';
    if (token != null) {
      headers['authorization'] = 'Bearer' + ' ' + token;
    }
    return headers;
  }

  /// common post request with a body
  static Future<BackEndResult> postRequest(
      Map<String, dynamic> dataObject, String requestPath) async {
    var json = await GlobalConfiguration()
        .loadFromPath('assets/cfg/configurations.json');
    var endPoint = GlobalConfiguration().getValue("backend_url");
    var url = endPoint + requestPath;
    Map<String, String> headers = generateHeaders();

    final response =
        await http.post(url, headers: headers, body: jsonEncode(dataObject));
    return new BackEndResult(response.statusCode, jsonDecode(response.body));
  }

  ///common get request with query params
  static Future<BackEndResult> getRequest(String requestPath) async {
    var json = await GlobalConfiguration()
        .loadFromPath('assets/cfg/configurations.json');
    var endPoint = GlobalConfiguration().getValue("backend_url");
    var url = endPoint + requestPath;
    Map<String, String> headers = generateHeaders();

    final response = await http.get(url, headers: headers);
    return new BackEndResult(response.statusCode, jsonDecode(response.body));
  }
}
