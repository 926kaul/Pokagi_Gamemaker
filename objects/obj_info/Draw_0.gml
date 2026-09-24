var _size = 44;
var _hover = point_in_rectangle(mouse_x, mouse_y, x, y, x + _size, y + _size);
ui_draw_panel(x, y, x + _size, y + _size, 8, _hover ? ui_colour("ivory") : ui_colour("cyan"));
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(Font5);
draw_set_colour(_hover ? ui_colour("ivory") : ui_colour("cyan"));
draw_text(x + _size * 0.5, y + _size * 0.5, "i");
