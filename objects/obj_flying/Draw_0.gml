if (!is_active) exit;

var _size = 64;
var _x1 = x - _size * 0.5;
var _y1 = y - _size * 0.5;
var _x2 = x + _size * 0.5;
var _y2 = y + _size * 0.5;
var _hover = point_in_circle(mouse_x, mouse_y, x, y, _size * 0.5);

ui_draw_panel(_x1, _y1, _x2, _y2, 9, _hover ? ui_colour("ivory") : ui_colour("gold"));

// A single swept wing: broad at the shoulder, split into three long feathers.
var _wing_colour = _hover ? ui_colour("ivory") : ui_colour("gold");
draw_set_colour(_wing_colour);
draw_primitive_begin(pr_trianglefan);
draw_vertex(x - 17, y + 13);
draw_vertex(x - 13, y - 7);
draw_vertex(x - 5, y - 18);
draw_vertex(x + 1, y - 5);
draw_vertex(x + 15, y - 16);
draw_vertex(x + 11, y - 1);
draw_vertex(x + 22, y - 5);
draw_vertex(x + 14, y + 8);
draw_vertex(x + 2, y + 15);
draw_primitive_end();

draw_set_colour(ui_colour("panel"));
draw_line_width(x - 6, y - 6, x + 14, y - 14, 1);
draw_line_width(x - 3, y + 2, x + 17, y - 3, 1);
draw_line_width(x, y + 9, x + 13, y + 7, 1);
draw_set_colour(ui_colour("cyan"));
draw_circle(x - 17, y + 13, 3, false);
