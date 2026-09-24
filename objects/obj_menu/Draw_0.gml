var _size = 44;
var _hover = point_in_rectangle(mouse_x, mouse_y, x, y, x + _size, y + _size);
ui_draw_panel(x, y, x + _size, y + _size, 8, _hover ? ui_colour("ivory") : ui_colour("gold"));
draw_set_colour(_hover ? ui_colour("ivory") : ui_colour("gold"));
for (var _ix = 0; _ix < 2; _ix++) {
    for (var _iy = 0; _iy < 2; _iy++) {
        draw_rectangle(x + 12 + _ix * 13, y + 12 + _iy * 13, x + 19 + _ix * 13, y + 19 + _iy * 13, true);
    }
}
