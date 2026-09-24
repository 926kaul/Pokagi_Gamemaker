var _size = 44;
var _hover = point_in_rectangle(mouse_x, mouse_y, x, y, x + _size, y + _size);
var _accent = _hover ? ui_colour("ivory") : ui_colour("gold");
ui_draw_panel(x, y, x + _size, y + _size, 8, _accent);

var _cx = x + _size * 0.5;
var _cy = y + _size * 0.5;
draw_set_colour(_accent);
for (var _tooth = 0; _tooth < 8; _tooth++) {
    var _angle = _tooth * 45;
    draw_line_width(
        _cx + dcos(_angle) * 10, _cy + dsin(_angle) * 10,
        _cx + dcos(_angle) * 15, _cy + dsin(_angle) * 15,
        4
    );
}
draw_circle(_cx, _cy, 11, true);
draw_circle(_cx, _cy, 4, true);
