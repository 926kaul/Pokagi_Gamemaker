info_opened = !info_opened;
modal_open_guard = info_opened;
if (info_opened) {
    if (instance_exists(obj_menu)) obj_menu.menu_opened = false;
    if (instance_exists(obj_settings)) obj_settings.settings_opened = false;
    if (instance_exists(obj_flying)) obj_flying.flying_opened = false;
}
