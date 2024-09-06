//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <background_location/background_location_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) background_location_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "BackgroundLocationPlugin");
  background_location_plugin_register_with_registrar(background_location_registrar);
}
