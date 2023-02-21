import 'dart:async';
import 'package:flutter/services.dart';

class FlutterFacebookAppLinks {
  static const MethodChannel _channel =
  const MethodChannel("plugins.remedia.it/flutter_facebook_app_links");

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<dynamic> initFBLinks() async {

    try{
      var data = await _channel.invokeMethod('initFBLinks');
      return data ?? '';
    }catch(_){
      return null;
    }

  }


  static Future<void> setAdvertiserTracking({
    required bool enabled,
    bool collectId = true,
  }) {
    final args = <String, dynamic>{
      'enabled': enabled,
      'collectId': collectId,
    };

    return _channel.invokeMethod<void>('setAdvertiserTracking', args);
  }

  static Future<String> getDeepLink() async {


    try{
      var data = await _channel.invokeMethod('getDeepLinkUrl');
      return data ?? '';

    }catch(_){
      return '';
    }
  }

}
