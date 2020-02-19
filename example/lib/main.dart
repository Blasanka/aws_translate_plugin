import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:aws_translate/aws_translate.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String poolId;
  String textToTranslate = 'If you press on this text, I can translate this text for you.';
  AwsTranslate awsTranslate;

  bool isToggle = false;

  @override
  void initState() {
    super.initState();
    awsTranslate = AwsTranslate();
    readEnv();
  }

  void readEnv() async {
    final str = await rootBundle.loadString(".env");
    if (str.isNotEmpty) {
      final decoded = jsonDecode(str);
      poolId = decoded["poolId"];
    }
    awsTranslate = AwsTranslate(
        poolId: poolId,
        region: Regions.US_WEST_2);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: StreamBuilder(
            stream: awsTranslate.getTranslateStatus,
            builder: (context, snapshot) {
              if (snapshot == null || snapshot.hasError) return Text("error");
              return InkWell(
                onTap: tapToTranslate,
                child: snapshot.data == TranslateStatus.TRANSLATING
                    ? CupertinoActivityIndicator()
                    : Padding(padding: EdgeInsets.all(10), child: Text(textToTranslate)),
              );
            }
          ),
        ),
      ),
    );
  }


//   with from and to optional params
//   onTap: () async => await AwsTranslate.translateText(textToTranslate, from: 'en', to: 'hi'),
  void tapToTranslate() async {

    // if you need to change the translating language when tap once use below
    // or just use your lang translate code directly to translateText function
    String translateTo = toggleTranslatingLangWhenOnTap();

    String translated = await awsTranslate.translateText(textToTranslate, to: translateTo);
    if (!mounted) return;
    print(textToTranslate);
    setState(() => textToTranslate = translated);
  }

  String toggleTranslatingLangWhenOnTap() {
    String translateTo = "es";
    if (isToggle) translateTo = "en";
    isToggle = !isToggle;
    return translateTo;
  }
}
