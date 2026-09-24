var _radius = max(16, sprite_get_width(sprite_index) * abs(image_xscale) * 0.5);
var _team_colour = ui_colour("gold");
if (team_is_player(owner)) _team_colour = ui_colour("cyan");
if (team_is_enemy(owner)) _team_colour = ui_colour("coral");

// Show the exact board intersection that will be used when placement ends.
if (is_placing && team_is_player(owner)) {
    var _target_x = board_snap(clamp(mouse_x, global.board.left, global.board.right), global.board.left);
    var _target_y = board_snap(clamp(mouse_y, global.board.top, global.board.bottom), global.board.top);
    var _target_valid = board_is_player_area(mouse_y)
        && board_player_placed_count() < 3
        && board_position_is_free(_target_x, _target_y, id);
    var _target_colour = _target_valid ? ui_colour("cyan") : ui_colour("coral");

    draw_set_colour(_target_colour);
    draw_set_alpha(0.10);
    draw_circle(_target_x, _target_y, 20, false);
    draw_set_alpha(0.18);
    draw_circle(_target_x, _target_y, 12, false);
    draw_set_alpha(0.34);
    draw_circle(_target_x, _target_y, 6, false);
    draw_set_alpha(1);
    ui_draw_diamond(_target_x, _target_y, 5, _target_colour, false);
}

// A soft ground shadow improves separation without enclosing the creature's
// silhouette or competing with its individual design.
draw_set_alpha(0.35);
draw_set_colour(c_black);
draw_ellipse(x - _radius - 3, y - _radius + 5, x + _radius + 3, y + _radius + 9, false);

draw_set_alpha(1);
image_blend = c_white;
draw_self();

// This is the deliberate pull vector, not a predicted trajectory.
if (is_shooting) {
    var _max_len = global.board.max_pull;
    var _distance = point_distance(x, y, mouse_x, mouse_y);
    var _line_x = mouse_x;
    var _line_y = mouse_y;
    if (_distance > _max_len) {
        var _direction = point_direction(x, y, mouse_x, mouse_y);
        _line_x = x + lengthdir_x(_max_len, _direction);
        _line_y = y + lengthdir_y(_max_len, _direction);
    }

    draw_set_alpha(0.35);
    draw_set_colour(ui_colour("ink"));
    draw_line_width(x, y, _line_x, _line_y, 6);
    draw_set_alpha(1);
    draw_set_colour(_team_colour);
    draw_line_width(x, y, _line_x, _line_y, 2);
    draw_circle(_line_x, _line_y, 5, true);
}

// Motion trail communicates speed after a shot without revealing its future path.
if (moving && array_length(trail) > 1) {
    draw_set_alpha(0.32);
    draw_set_colour(_team_colour);
    for (var _i = 1; _i < array_length(trail); _i++) {
        var _previous = trail[_i - 1];
        var _current = trail[_i];
        draw_line(_previous[0], _previous[1], _current[0], _current[1]);
    }
    draw_set_alpha(1);
}

if (current_turn && !moving) {
    ui_draw_diamond(x, y - _radius - 15, 6, ui_colour("ivory"), true);
    draw_set_font(Font5);
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_colour(c_black);
    draw_text(x, y - _radius - 24, team_is_player(owner) ? "READY" : "RIVAL");
}

draw_set_alpha(1);
draw_set_colour(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
