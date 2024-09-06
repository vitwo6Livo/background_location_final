#include "include/background_location/background_location_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "background_location_plugin.h"

void BackgroundLocationPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  background_location::BackgroundLocationPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
