import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class AwsTranslate {

  final String poolId;
  final Regions region;

  static const MethodChannel _channel =
  const MethodChannel('com.blasanka.translateFlutter/aws_translate');

  StreamController<TranslateStatus> translatingStateController = StreamController<TranslateStatus>();

  AwsTranslate({
    this.poolId,
    this.region
  }) {
    translatingStateController.add(TranslateStatus.NONE);
  }

  Stream<TranslateStatus> get getTranslateStatus => translatingStateController.stream;

  Future<String> translateText(String text, {@required String to, String from = "auto"}) async {

    translatingStateController.add(TranslateStatus.TRANSLATING);

    String result = "";

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {

      Map<String, dynamic> args = <String, dynamic>{};
      args.putIfAbsent("poolId", () => poolId);
      args.putIfAbsent("region", () => region.toString());
      args.putIfAbsent("text", () => text);
      args.putIfAbsent("from", () => from);
      args.putIfAbsent("to", () => to);

      result = await _channel.invokeMethod("translateText", args);
      translatingStateController.add(TranslateStatus.COMPLETED);
    } on PlatformException catch(e) {
      result = null;
      debugPrint(e.message);
      translatingStateController.add(TranslateStatus.ERROR);
    }

    return result;
  }
}

enum TranslateStatus {
  NONE,
  ERROR,
  TRANSLATING,
  COMPLETED
}

/// Enumeration of region names
enum Regions {
  GovCloud,
  US_GOV_EAST_1,
  US_EAST_1,
  US_EAST_2,
  US_WEST_1,
  US_WEST_2, ///Default: The default region of AWS Android SDK
  EU_WEST_1,
  EU_WEST_2,
  EU_WEST_3,
  EU_CENTRAL_1,
  EU_NORTH_1,
  AP_EAST_1,
  AP_SOUTH_1,
  AP_SOUTHEAST_1,
  AP_SOUTHEAST_2,
  AP_NORTHEAST_1,
  AP_NORTHEAST_2,
  SA_EAST_1,
  CA_CENTRAL_1,
  CN_NORTH_1,
  CN_NORTHWEST_1,
  ME_SOUTH_1
}