var _caught_count = 0;
for (var _caught_index = 0; _caught_index < array_length(my_pokes); _caught_index++) {
    if (my_pokes[_caught_index] == 1) _caught_count++;
}

var _bx1 = x;
var _by1 = y;
var _bx2 = x + 64;
var _by2 = y + 64;
var _collection_locked = instance_exists(obj_tutorial1);
var _hover = !_collection_locked
    && point_in_rectangle(mouse_x, mouse_y, _bx1, _by1, _bx2, _by2);

// Team building begins only after the first partner has been chosen.
if (_collection_locked && pokeball_opened) {
    pokeball_opened = false;
    clear_pokeball_instances();
}

if (_hover && !obj_controller.battle_ready && mouse_check_button_pressed(mb_left)) {
    pokeball_opened = !pokeball_opened;
    if (pokeball_opened) {
        create_pokeball_instances();
    } else {
        clear_pokeball_instances();
    }
}

var _button_colour = _collection_locked
    ? ui_colour("muted")
    : (_hover ? ui_colour("ivory") : ui_colour("cyan"));
ui_draw_panel(_bx1, _by1, _bx2, _by2, 9, _button_colour);
draw_set_colour(_button_colour);
draw_circle(x + 32, y + 27, 15, true);
draw_line_width(x + 18, y + 27, x + 46, y + 27, 2);
draw_circle(x + 32, y + 27, 5, false);
draw_set_font(Font5);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_colour(ui_colour("muted"));
draw_text(x + 32, y + 51, string(_caught_count) + "/151");

if (pokeball_opened && !obj_controller.battle_ready) {
    var _drawer_x1 = collection_panel_x1;
    var _drawer_y1 = collection_panel_y1;
    var _drawer_x2 = collection_panel_x2;
    var _drawer_y2 = collection_panel_y2;
    var _hovered_pokemon = 0;

    // A generous circular hit target keeps the compact 151-slot grid usable.
    with (obj_ball) {
        if (team_is_player(owner) && !placed
            && point_distance(x, y, mouse_x, mouse_y) <= 12) {
            _hovered_pokemon = pokemon_id;
            if (mouse_check_button_pressed(mb_left)) {
                is_placing = true;
                if (!has_collection_home) {
                    original_x = x;
                    original_y = y;
                }
            }
        }
    }

    draw_set_colour(ui_colour("ink"));
    draw_roundrect_ext(_drawer_x1, _drawer_y1, _drawer_x2, _drawer_y2, 12, 12, false);
    draw_set_colour(ui_colour("cyan"));
    draw_roundrect_ext(_drawer_x1, _drawer_y1, _drawer_x2, _drawer_y2, 12, 12, true);
    draw_set_colour(ui_colour("panel_hi"));
    draw_roundrect_ext(_drawer_x1 + 4, _drawer_y1 + 4, _drawer_x2 - 4, _drawer_y2 - 4, 9, 9, false);
    draw_set_colour(ui_colour("panel"));
    draw_roundrect_ext(_drawer_x1 + 8, _drawer_y1 + 8, _drawer_x2 - 8, _drawer_y1 + 72, 7, 7, false);
    draw_set_colour(ui_colour("ink"));
    draw_roundrect_ext(_drawer_x1 + 8, _drawer_y1 + 80, _drawer_x2 - 8, _drawer_y2 - 10, 7, 7, false);
    draw_set_colour(ui_colour("cyan"));
    draw_line_width(_drawer_x1 + 12, _drawer_y1 + 1, _drawer_x2 - 12, _drawer_y1 + 1, 2);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(Font5);
    draw_set_colour(ui_colour("ivory"));
    draw_text(_drawer_x1 + 14, _drawer_y1 + 13, "지닌 포켓몬");
    draw_set_font(Font6);
    draw_set_colour(ui_colour("muted"));
    draw_text(_drawer_x1 + 14, _drawer_y1 + 43, "드래그해 내 진영에 배치 · 최대 3마리");
    draw_set_halign(fa_right);
    draw_set_colour(ui_colour("cyan"));
    draw_text(_drawer_x2 - 14, _drawer_y1 + 18,
        _hovered_pokemon > 0 ? "#" + string(_hovered_pokemon) : string(_caught_count) + "/151");

    draw_set_colour(make_colour_rgb(55, 69, 78));
    draw_line(_drawer_x1 + 12, _drawer_y1 + 72, _drawer_x2 - 12, _drawer_y1 + 72);

    // The screen and its icons are redrawn together above the arena.
    with (obj_ball) {
        if (team_is_player(owner) && !placed) {
            if (pokemon_id == _hovered_pokemon) {
                draw_set_alpha(0.24);
                draw_set_colour(ui_colour("cyan"));
                draw_circle(x, y, 13, false);
            }
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
