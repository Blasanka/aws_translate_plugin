# aws_translate

AWS Translate plugin to translate a text / paragraph with translating status.

DISCLAIMER: This is not an AWS officially released plugin but this plugin uses 
AWS official Android native and IOS native AWS plugins (So nothing to be worried). 
Check the package implementation on github: https://github.com/Blasanka/aws_translate_plugin

All the support translate languages by AWS official Android and IOS libraries are supported
in this plugin also with `auto`.

Available languages:

Please refer this for support languages and their codes: 
https://docs.aws.amazon.com/translate/latest/dg/translate-dg.pdf

Example:
```
AwsTranslate awsTranslate = AwsTranslate(
    poolId: poolId, // your pool id here
    region: Regions.AP_NORTHEAST_2); // your region here

// from parameter is default to ``auto``
String textToTranslate = 'If you press on this text, I can translate this text for you.';
String translated = await awsTranslate.translateText(textToTranslate, to: 'es');
if (!mounted) return;
print(textToTranslate);
setState(() => textToTranslate = translated);
```
A complete example can be found in the example directory.

All available regions for Android are support for this Flutter plugin.

```
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
```

For to show something while translate, use `getTranslateStatus` and
below are supported translate types:

```
enum TranslateStatus {
  NONE,
  ERROR,
  TRANSLATING,
  COMPLETED
}
```

Contributes and issues are welcome!