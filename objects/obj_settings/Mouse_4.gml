settings_opened = !settings_opened;
modal_open_guard = settings_opened;
volume_dragging = false;
if (settings_opened) {
    if (instance_exists(obj_menu)) obj_menu.menu_opened = false;
    if (instance_exists(obj_info)) obj_info.info_opened = false;
    if (instance_exists(obj_flying)) obj_flying.flying_opened = false;
}
