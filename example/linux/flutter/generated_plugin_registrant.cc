//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <net_assistant/net_assistant_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) net_assistant_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "NetAssistantPlugin");
  net_assistant_plugin_register_with_registrar(net_assistant_registrar);
}
