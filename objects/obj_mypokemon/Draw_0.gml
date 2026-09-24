var _caught_count = 0;
for (var _caught_index = 0; _caught_index < array_length(my_pokes); _caught_index++) {
    if (my_pokes[_caught_index] == 1) _caught_count++;
}

var _bx1 = x;
var _by1 = y;
var _bx2 = x + 64;
var _by2 = y + 64;
var _hover = point_in_rectangle(mouse_x, mouse_y, _bx1, _by1, _bx2, _by2);

if (_hover && !obj_controller.battle_ready && mouse_check_button_pressed(mb_left)) {
    pokeball_opened = !pokeball_opened;
    if (pokeball_opened) {
        create_pokeball_instances();
    } else {
        clear_pokeball_instances();
    }
}

ui_draw_panel(_bx1, _by1, _bx2, _by2, 9, _hover ? ui_colour("ivory") : ui_colour("cyan"));
draw_set_colour(_hover ? ui_colour("ivory") : ui_colour("cyan"));
draw_circle(x + 32, y + 27, 15, true);
draw_line_width(x + 18, y + 27, x + 46, y + 27, 2);
draw_circle(x + 32, y + 27, 5, false);
draw_set_font(Font5);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_colour(ui_colour("muted"));
draw_text(x + 32, y + 51, string(_caught_count) + "/151");

if (pokeball_opened && !obj_controller.battle_ready) {
    var _drawer_x1 = 20;
    var _drawer_y1 = 18;
    var _drawer_x2 = 956;
    var _drawer_y2 = 474;

    // Draw the page and its Pokemon in one existing Draw event. This keeps the
    // background and icons inseparable even while the project is open in the IDE.
    draw_set_alpha(0.55);
    draw_set_colour(ui_colour("ink"));
    draw_rectangle(0, 0, 960, 474, false);
    draw_set_alpha(1);

    draw_set_colour(ui_colour("ink"));
    draw_roundrect_ext(_drawer_x1, _drawer_y1, _drawer_x2, _drawer_y2, 16, 16, false);
    draw_set_colour(ui_colour("cyan"));
    draw_roundrect_ext(_drawer_x1, _drawer_y1, _drawer_x2, _drawer_y2, 16, 16, true);
    draw_set_colour(ui_colour("panel_hi"));
    draw_roundrect_ext(_drawer_x1 + 5, _drawer_y1 + 5, _drawer_x2 - 5, _drawer_y2 - 5, 11, 11, false);
    draw_set_colour(ui_colour("panel"));
    draw_roundrect_ext(_drawer_x1 + 12, _drawer_y1 + 12, _drawer_x2 - 12, _drawer_y1 + 88, 8, 8, false);
    draw_set_colour(ui_colour("ink"));
    draw_roundrect_ext(_drawer_x1 + 16, _drawer_y1 + 94, _drawer_x2 - 16, _drawer_y2 - 16, 8, 8, false);
    draw_set_colour(ui_colour("cyan"));
    draw_line_width(_drawer_x1 + 14, _drawer_y1 + 1, _drawer_x2 - 14, _drawer_y1 + 1, 2);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(Font5);
    draw_set_colour(ui_colour("ivory"));
    draw_text(_drawer_x1 + 24, _drawer_y1 + 20, "지닌 포켓몬");
    draw_set_colour(ui_colour("muted"));
    draw_text(_drawer_x1 + 24, _drawer_y1 + 50, "최대 3마리를 드래그해 내 진영에 배치하세요");
    draw_set_halign(fa_right);
    draw_set_colour(ui_colour("cyan"));
    draw_text(_drawer_x2 - 24, _drawer_y1 + 34, string(_caught_count) + "마리 보유");

    draw_set_colour(make_colour_rgb(55, 69, 78));
    draw_line(_drawer_x1 + 20, _drawer_y1 + 78, _drawer_x2 - 20, _drawer_y1 + 78);

    // The panel is drawn after normal room instances, so redraw only the loose
    // collection Pokemon here, directly above their own background.
    with (obj_ball) {
        if (team_is_player(owner) && !placed) {
            draw_set_alpha(1);
            image_blend = c_white;
            draw_self();
        }
    }

    if (mouse_check_button_pressed(mb_left)
        && !point_in_rectangle(mouse_x, mouse_y, _drawer_x1, _drawer_y1, _drawer_x2, _drawer_y2)
        && !point_in_rectangle(mouse_x, mouse_y, x, y, x + 64, y + 64)) {
        pokeball_opened = false;
        clear_pokeball_instances();
    }
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
