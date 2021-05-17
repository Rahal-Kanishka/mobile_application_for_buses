

import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter_with_maps/models/user.dart';

import 'backend.dart';

/// Class to provide common Util functionalities
class Common {

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png)).buffer.asUint8List();
  }

  static Future<User> getUserDetails(String userID) async {
    Map<String, String> userAccountParams = {
      'user_id': userID
    };
    BackEndResult backEndResult =
        await BackEnd.getRequest('/user/user', userAccountParams);

    if (backEndResult.statusCode == 200 && backEndResult.responseBody != null) {
      return User.fromJson(backEndResult.responseBody);
    } else {
      return null;
    }
  }
}