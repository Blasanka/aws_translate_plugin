import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aws_translate/aws_translate.dart';

void main() {
  const MethodChannel channel = MethodChannel('com.blasanka.s3Flutter/aws_translate');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return 'translateText';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('translateText', () async {
    expect(await AwsTranslate(
      poolId: "",
      region: Regions.AP_SOUTHEAST_2,
    ).translateText("Thank you", to: 'es'), 'Gracious');
  });
}
