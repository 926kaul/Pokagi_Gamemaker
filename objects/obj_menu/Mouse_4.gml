menu_opened = !menu_opened;
modal_open_guard = menu_opened;
if (menu_opened) {
    if (instance_exists(obj_info)) obj_info.info_opened = false;
    if (instance_exists(obj_settings)) obj_settings.settings_opened = false;
}
