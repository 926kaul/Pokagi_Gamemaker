var _x1 = x - 60;
var _y1 = y - 34;
var _x2 = x + 150;
var _y2 = y + 30;
var _hover = point_in_rectangle(mouse_x, mouse_y, _x1, _y1, _x2, _y2);

ui_draw_panel(_x1, _y1, _x2, _y2, 10, _hover ? ui_colour("ivory") : ui_colour("coral"));
draw_set_colour(_hover ? ui_colour("ivory") : ui_colour("coral"));
draw_roundrect_ext(_x1 + 7, _y1 + 7, _x2 - 7, _y2 - 7, 7, 7, false);

draw_set_font(Font5);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_colour(ui_colour("ink"));
draw_text((_x1 + _x2) * 0.5, (_y1 + _y2) * 0.5, "START BATTLE");
