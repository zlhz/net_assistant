#ifndef FLUTTER_PLUGIN_NET_ASSISTANT_PLUGIN_H_
#define FLUTTER_PLUGIN_NET_ASSISTANT_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace net_assistant {

class NetAssistantPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  NetAssistantPlugin();

  virtual ~NetAssistantPlugin();

  // Disallow copy and assign.
  NetAssistantPlugin(const NetAssistantPlugin&) = delete;
  NetAssistantPlugin& operator=(const NetAssistantPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace net_assistant

#endif  // FLUTTER_PLUGIN_NET_ASSISTANT_PLUGIN_H_
