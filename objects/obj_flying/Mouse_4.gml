if (is_active) {
    flying_opened = !flying_opened;
    modal_open_guard = flying_opened;
    if (flying_opened) {
        if (instance_exists(obj_menu)) obj_menu.menu_opened = false;
        if (instance_exists(obj_info)) obj_info.info_opened = false;
        if (instance_exists(obj_settings)) obj_settings.settings_opened = false;
    }
}
