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
  static Future<BackEndResult> postRequest(Map<String, dynamic> dataObject,
      String requestPath) async {
    var json = await GlobalConfiguration()
        .loadFromPath('assets/cfg/configurations.json');
    var endPoint = GlobalConfiguration().getValue("backend_url");
    var url = endPoint + requestPath;
    Map<String, String> headers = generateHeaders();
    var response;
    var backEndResult;
    try {
      response =
      await http.post(url, headers: headers, body: jsonEncode(dataObject));
      backEndResult =
          BackEndResult(response.statusCode, jsonDecode(response.body));
    } catch (e) {
      print('error in post: $e');
      backEndResult = new BackEndResult(null, e.toString());
    }
    return backEndResult;
  }

  ///common get request with query params
  static Future<BackEndResult> getRequest(String requestPath,
      [Map<String, String> queryParams]) async {
    var json = await GlobalConfiguration()
        .loadFromPath('assets/cfg/configurations.json');
    var endPoint = GlobalConfiguration().getValue("backend_url");
    var url;
    if(queryParams != null) {
      String queryString = Uri(queryParameters: queryParams).query;
      url = endPoint + requestPath + '?' + queryString;
    } else {
      url = endPoint + requestPath;
    }
    Map<String, String> headers = generateHeaders();

    final response = await http.get(url, headers: headers);
    return new BackEndResult(response.statusCode,
        response.body != null && response.body != "" ? jsonDecode(response.body) : null);
  }
}
