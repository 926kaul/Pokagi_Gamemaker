/// Shared visual language for the remaster UI.
function ui_colour(_name) {
    switch (_name) {
        case "ink":      return make_colour_rgb(9, 16, 27);
        case "panel":    return make_colour_rgb(18, 31, 47);
        case "panel_hi": return make_colour_rgb(27, 47, 65);
        case "ivory":    return make_colour_rgb(235, 213, 166);
        case "muted":    return make_colour_rgb(139, 151, 157);
        case "coral":    return make_colour_rgb(207, 91, 78);
        case "cyan":     return make_colour_rgb(74, 176, 184);
        case "gold":     return make_colour_rgb(222, 177, 96);
    }
    return c_white;
}

function ui_draw_panel(_x1, _y1, _x2, _y2, _radius, _accent) {
    draw_set_alpha(0.96);
    draw_set_colour(ui_colour("ink"));
    draw_roundrect_ext(_x1, _y1, _x2, _y2, _radius, _radius, false);
    draw_set_alpha(1);

    draw_set_colour(ui_colour("panel_hi"));
    draw_roundrect_ext(_x1 + 3, _y1 + 3, _x2 - 3, _y2 - 3, max(2, _radius - 2), max(2, _radius - 2), true);
    draw_set_colour(_accent);
    draw_line_width(_x1 + 14, _y1 + 1, _x2 - 14, _y1 + 1, 2);
}

function ui_draw_diamond(_x, _y, _size, _colour, _filled) {
    draw_set_colour(_colour);
    draw_primitive_begin(_filled ? pr_trianglefan : pr_linestrip);
    if (_filled) draw_vertex(_x, _y);
    draw_vertex(_x, _y - _size);
    draw_vertex(_x + _size, _y);
    draw_vertex(_x, _y + _size);
    draw_vertex(_x - _size, _y);
    draw_vertex(_x, _y - _size);
    draw_primitive_end();
}

function ui_draw_arena() {
    var _left = global.board.left;
    var _top = global.board.top;
    var _right = global.board.right;
    var _bottom = global.board.bottom;
    var _grid = global.board.grid_size;

    draw_clear(ui_colour("ink"));

    // Warm wooden slab with a margin outside the playable intersections.
    var _wood_dark = make_colour_rgb(92, 58, 31);
    var _wood_mid = make_colour_rgb(195, 146, 82);
    var _wood_light = make_colour_rgb(218, 174, 105);
    var _grid_ink = make_colour_rgb(55, 39, 25);
    // Keep the top frame below the HUD while preserving gameplay coordinates.
    // The other three sides retain their deeper wooden rim.
    var _frame_top_outer = _top - 8;
    var _frame_top_mid = _top - 5;
    var _frame_top_inner = _top - 2;

    draw_set_colour(_wood_dark);
    draw_roundrect_ext(_left - 26, _frame_top_outer, _right + 26, _bottom + 26, 12, 12, false);
    draw_set_colour(_wood_mid);
    draw_roundrect_ext(_left - 20, _frame_top_mid, _right + 20, _bottom + 20, 9, 9, false);
    draw_set_colour(_wood_light);
    draw_rectangle(_left - 14, _frame_top_inner, _right + 14, _bottom + 14, false);

    // Subtle horizontal grain keeps the surface tactile without reducing clarity.
    draw_set_alpha(0.12);
    for (var _grain_y = _top + 2; _grain_y <= _bottom + 8; _grain_y += 23) {
        draw_set_colour(((_grain_y div 23) mod 2) == 0 ? _wood_dark : c_white);
        draw_line(_left - 10, _grain_y, _right + 10, _grain_y);
        draw_line(_left + 70, _grain_y + 3, _right - 90, _grain_y + 3);
    }
    draw_set_alpha(1);

    // Exact 19x19 Go grid; visuals and snap coordinates share one source.
    draw_set_colour(_grid_ink);
    for (var _x = _left; _x <= _right; _x += _grid) {
        draw_line(_x, _top, _x, _bottom);
    }
    for (var _y = _top; _y <= _bottom; _y += _grid) {
        draw_line(_left, _y, _right, _y);
    }

    draw_set_colour(_wood_dark);
    draw_rectangle(_left - 15, _top - 3, _right + 15, _bottom + 15, true);

    // Side ownership is shown at the rim instead of tinting the wooden board.
    draw_set_colour(ui_colour("coral"));
    draw_roundrect_ext(_left, _top - 8, _right, _top - 3, 2, 2, false);
    draw_set_colour(ui_colour("cyan"));
    draw_roundrect_ext(_left, _bottom + 17, _right, _bottom + 22, 2, 2, false);

    // The extra 320 logical pixels form a permanent command rail.
    ui_draw_panel(968, 112, room_width - 16, 848, 14, ui_colour("gold"));
    draw_set_colour(make_colour_rgb(55, 69, 78));
    draw_line(992, 628, room_width - 40, 628);
    draw_line(992, 736, room_width - 40, 736);

    // Traditional 19x19 hoshi arrangement: 3, 9 and 15 intervals.
    var _hoshi = [3, 9, 15];
    draw_set_colour(_grid_ink);
    for (var _hy = 0; _hy < array_length(_hoshi); _hy++) {
        for (var _hx = 0; _hx < array_length(_hoshi); _hx++) {
            var _star_x = _left + _grid * _hoshi[_hx];
            var _star_y = _top + _grid * _hoshi[_hy];
            draw_circle(_star_x, _star_y, (_hx == 1 && _hy == 1) ? 6 : 5, false);
        }
    }
}
