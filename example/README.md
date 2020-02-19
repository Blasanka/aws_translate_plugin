# aws_translate_example

Demonstrates how to use the aws_translate plugin.

In this example I have loaded poolId from a file for privacy reasons.
You can directly specify your pool id (not recommended). Or load it from a `.env`
to improve security.

Copy of the `example/lib/main.dart`:
```
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
```

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
