#include "include/net_assistant/net_assistant_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "net_assistant_plugin.h"

void NetAssistantPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  net_assistant::NetAssistantPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
