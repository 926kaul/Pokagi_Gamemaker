if (!is_active) {
    flying_opened = false;
    modal_open_guard = false;
    exit;
}

var _mx = mouse_x;
var _my = mouse_y;

if (!flying_opened) {
    modal_open_guard = false;
} else {
    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();
    var _x1 = 36;
    var _y1 = 500;
    var _x2 = _gui_w - 36;
    var _y2 = _gui_h - 34;

    draw_set_alpha(0.45);
    draw_set_colour(ui_colour("ink"));
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
    draw_set_alpha(1);
    ui_draw_panel(_x1, _y1, _x2, _y2, 16, ui_colour("gold"));

    draw_set_font(Font5);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_colour(ui_colour("ivory"));
    draw_text(_x1 + 24, _y1 + 22, "공중날기");
    draw_set_font(Font5);
    draw_set_colour(ui_colour("muted"));
    draw_text(_x1 + 24, _y1 + 50, "발견한 스테이지를 선택하세요");

    var _rooms = [Room1, Room2_1, Room3_1, Room4_1, Room5_1, Room6_1, Room7_1, Room8_1, Room9_1, Room10];
    var _cols = 5;
    var _padding = 12;
    var _content_y = _y1 + 88;
    var _btn_w = ((_x2 - _x1) - _padding * 6) / _cols;
    var _btn_h = ((_y2 - _content_y) - _padding * 3) / 2;
    var _any_button_clicked = false;
    var _page_click = false;

    // The physical click that opened the page must not also select the stage
    // underneath the wing button. Accept page clicks only after release.
    if (modal_open_guard) {
        if (!mouse_check_button(mb_left)) modal_open_guard = false;
    } else {
        _page_click = mouse_check_button_pressed(mb_left);
    }

    for (var _i = 0; _i < array_length(_rooms); _i++) {
        var _col = _i mod _cols;
        var _row = _i div _cols;
        var _bx1 = _x1 + _padding + _col * (_btn_w + _padding);
        var _by1 = _content_y + _padding + _row * (_btn_h + _padding);
        var _bx2 = _bx1 + _btn_w;
        var _by2 = _by1 + _btn_h;
        var _hover = point_in_rectangle(_mx, _my, _bx1, _by1, _bx2, _by2);
        var _accent = _hover ? ui_colour("ivory") : ui_colour("cyan");

        ui_draw_panel(_bx1, _by1, _bx2, _by2, 8, _accent);
        ui_draw_diamond(_bx1 + 22, (_by1 + _by2) * 0.5, 6, _accent, true);

        var _raw_name = room_get_name(_rooms[_i]);
        var _display_number = string_replace(_raw_name, "Room", "");
        if (_display_number == "") _display_number = "1";

        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_font(Font5);
        draw_set_colour(_hover ? ui_colour("ivory") : ui_colour("muted"));
        draw_text((_bx1 + _bx2) * 0.5 + 8, (_by1 + _by2) * 0.5, "STAGE " + _display_number);

        if (_hover && _page_click) {
            _any_button_clicked = true;
            flying_opened = false;
            room_goto(_rooms[_i]);
        }
    }

    if (!_any_button_clicked && _page_click
        && !point_in_rectangle(_mx, _my, _x1, _y1, _x2, _y2)) {
        flying_opened = false;
    }
}

draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
