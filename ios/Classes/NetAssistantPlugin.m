#import "NetAssistantPlugin.h"
#if __has_include(<net_assistant/net_assistant-Swift.h>)
#import <net_assistant/net_assistant-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "net_assistant-Swift.h"
#endif

@implementation NetAssistantPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNetAssistantPlugin registerWithRegistrar:registrar];
}
@end
