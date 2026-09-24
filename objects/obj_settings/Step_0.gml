if (!settings_opened) {
    volume_dragging = false;
    exit;
}

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();
var _page_x1 = (_gui_w - 620) * 0.5;
var _page_y1 = (_gui_h - 360) * 0.5;
var _bar_x = _page_x1 + 150;
var _bar_y = _page_y1 + 205;
var _mouse_x = device_mouse_x_to_gui(0);
var _mouse_y = device_mouse_y_to_gui(0);
var _bar_hit = point_in_rectangle(
    _mouse_x, _mouse_y,
    _bar_x - 10, _bar_y - 14,
    _bar_x + volume_bar_width + 10, _bar_y + volume_bar_height + 14
);

if (mouse_check_button_pressed(mb_left) && _bar_hit) {
    volume_dragging = true;
}
if (!mouse_check_button(mb_left)) {
    volume_dragging = false;
}
if (volume_dragging) {
    global.master_volume = clamp((_mouse_x - _bar_x) / volume_bar_width, 0, 1);
    set_master_volume(global.master_volume);
}
