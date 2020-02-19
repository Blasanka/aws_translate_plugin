#import "AwsTranslatePlugin.h"
#if __has_include(<aws_translate/aws_translate-Swift.h>)
#import <aws_translate/aws_translate-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "aws_translate-Swift.h"
#endif

@implementation AwsTranslatePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAwsTranslatePlugin registerWithRegistrar:registrar];
}
@end
