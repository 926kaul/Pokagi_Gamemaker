// Square vector type chart driven by the same matrix used in battle.
if (menu_opened) {
    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();
    var _ivory = ui_colour("ivory");
    var _muted = ui_colour("muted");
    var _ink = ui_colour("ink");
    var _panel = ui_colour("panel");
    var _gold = ui_colour("gold");
    var _divider = make_colour_rgb(55, 69, 78);

    // Every result cell stays white; colour belongs only to the symbol.
    var _cell_fill = c_white;
    var _strong_symbol = make_colour_rgb(226, 52, 62);
    var _weak_symbol = make_colour_rgb(68, 166, 74);
    var _immune_symbol = make_colour_rgb(25, 29, 32);

    var _x1 = 120;
    var _y1 = 72;
    var _x2 = _gui_w - 120;
    var _y2 = _gui_h - 72;

    draw_set_alpha(0.8);
    draw_set_colour(_ink);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
    draw_set_alpha(1);
    ui_draw_panel(_x1, _y1, _x2, _y2, 16, _gold);

    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_set_font(Font5);
    draw_set_colour(_ivory);
    draw_text(_x1 + 28, _y1 + 28, "타입 상성표");
    draw_set_font(Font6);
    draw_set_colour(_muted);
    draw_text(_x1 + 28, _y1 + 52, "관동 도감 기준 · 공격 행 / 방어 열");

    var _cell = 45;
    var _type_count = 15;
    var _table_size = (_type_count + 1) * _cell;
    var _table_x = (_gui_w - _table_size) * 0.5;
    var _table_y = 144;
    var _data_x = _table_x + _cell;
    var _data_y = _table_y + _cell;

    // UI and room coordinates both use the fixed 1600x960 logical space.
    // mouse_x/y remain correct when HTML5 enlarges only the backing store.
    var _mx = mouse_x;
    var _my = mouse_y;
    var _hover_atk = 0;
    var _hover_def = 0;
    if (point_in_rectangle(
        _mx, _my,
        _data_x, _data_y,
        _data_x + _cell * _type_count - 1,
        _data_y + _cell * _type_count - 1
    )) {
        _hover_def = floor((_mx - _data_x) / _cell) + 1;
        _hover_atk = floor((_my - _data_y) / _cell) + 1;
    }

    // Legend panel uses the exact same square cells and symbols as the table.
    var _legend_x = _x1 + 28;
    var _legend_y = _table_y + 30;
    draw_set_halign(fa_left);
    draw_set_font(Font5);
    draw_set_colour(_ivory);
    draw_text(_legend_x, _legend_y - 22, "표시 기호");
    draw_set_font(Font6);
    var _legend_colours = [_cell_fill, _cell_fill, _cell_fill, _cell_fill];
    var _legend_symbols = [_immune_symbol, _strong_symbol, _weak_symbol, _immune_symbol];
    var _legend_values = [1, 2, 0.5, 0];
    var _legend_names = ["보통", "강함", "반감", "무효"];
    for (var _legend_i = 0; _legend_i < 4; _legend_i++) {
        var _legend_cell_y = _legend_y + _legend_i * 58;
        var _legend_fill = _legend_colours[_legend_i];
        draw_set_colour(_legend_fill);
        draw_rectangle(
            _legend_x, _legend_cell_y,
            _legend_x + _cell, _legend_cell_y + _cell,
            false
        );
        draw_set_colour(_divider);
        draw_rectangle(
            _legend_x, _legend_cell_y,
            _legend_x + _cell, _legend_cell_y + _cell,
            true
        );
        ui_draw_matchup_symbol(
            _legend_x + _cell * 0.5,
            _legend_cell_y + _cell * 0.5,
            _legend_values[_legend_i],
            _legend_symbols[_legend_i],
            _legend_fill
        );
        draw_set_colour(_ivory);
        draw_text(_legend_x + _cell + 14, _legend_cell_y + _cell * 0.5,
            _legend_names[_legend_i]);
    }
    draw_set_colour(_muted);
    draw_text(_legend_x, _legend_y + 252, "기호를 함께 사용합니다");

    // Dark gutters make every 45x45 cell read as an independent square.
    draw_set_colour(_divider);
    draw_rectangle(
        _table_x - 2, _table_y - 2,
        _table_x + _table_size + 2, _table_y + _table_size + 2,
        false
    );

    // Top-left direction key.
    draw_set_colour(_panel);
    draw_rectangle(
        _table_x + 1, _table_y + 1,
        _table_x + _cell - 1, _table_y + _cell - 1,
        false
    );
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_font(Font6);
    draw_set_colour(_muted);
    draw_text(_table_x + _cell * 0.5, _table_y + 14, "방어");
    draw_text(_table_x + _cell * 0.5, _table_y + 31, "공격");

    // Defending-type header squares.
    for (var _def_type = 1; _def_type <= _type_count; _def_type++) {
        var _header_x = _data_x + (_def_type - 1) * _cell;
        var _header_colour = merge_colour(pokemon_type_colour(_def_type), _ink, 0.18);
        draw_set_colour(_header_colour);
        draw_rectangle(
            _header_x + 1, _table_y + 1,
            _header_x + _cell - 1, _table_y + _cell - 1,
            false
        );
        ui_draw_text_outline(
            _header_x + _cell * 0.5, _table_y + _cell * 0.5,
            pokemon_type_name(_def_type), c_white, c_black
        );
    }

    // Attacking-type header squares and the 15x15 result grid.
    for (var _atk_type = 1; _atk_type <= _type_count; _atk_type++) {
        var _row_y = _data_y + (_atk_type - 1) * _cell;
        var _row_colour = merge_colour(pokemon_type_colour(_atk_type), _ink, 0.18);
        draw_set_colour(_row_colour);
        draw_rectangle(
            _table_x + 1, _row_y + 1,
            _table_x + _cell - 1, _row_y + _cell - 1,
            false
        );
        ui_draw_text_outline(
            _table_x + _cell * 0.5, _row_y + _cell * 0.5,
            pokemon_type_name(_atk_type), c_white, c_black
        );

        for (var _def_type = 1; _def_type <= _type_count; _def_type++) {
            var _column_x = _data_x + (_def_type - 1) * _cell;
            var _multiplier = global.typevs[_atk_type][_def_type];
            var _fill = _cell_fill;
            var _symbol_colour = _ink;
            if (_multiplier == 2) {
                _symbol_colour = _strong_symbol;
            } else if (_multiplier == 0.5) {
                _symbol_colour = _weak_symbol;
            } else if (_multiplier == 0) {
                _symbol_colour = _immune_symbol;
            }

            draw_set_colour(_fill);
            draw_rectangle(
                _column_x + 1, _row_y + 1,
                _column_x + _cell - 1, _row_y + _cell - 1,
                false
            );
            ui_draw_matchup_symbol(
                _column_x + _cell * 0.5,
                _row_y + _cell * 0.5,
                _multiplier, _symbol_colour, _fill
            );
        }
    }

    // Hovering a result highlights both headers and the exact intersection.
    if (_hover_atk > 0 && _hover_def > 0) {
        var _hover_x = _data_x + (_hover_def - 1) * _cell;
        var _hover_y = _data_y + (_hover_atk - 1) * _cell;
        var _hover_header_x = _data_x + (_hover_def - 1) * _cell;
        var _hover_header_y = _data_y + (_hover_atk - 1) * _cell;
        draw_set_colour(_gold);

        // Continuous guides keep the chosen row and column visible across the
        // full matrix, even when the cursor is near its centre.
        for (var _guide_line = 0; _guide_line < 3; _guide_line++) {
            draw_rectangle(_hover_x + _guide_line, _table_y + _guide_line,
                _hover_x + _cell - _guide_line, _table_y + _table_size - _guide_line, true);
            draw_rectangle(_table_x + _guide_line, _hover_y + _guide_line,
                _table_x + _table_size - _guide_line, _hover_y + _cell - _guide_line, true);
        }

        // Four-pixel header outlines make the selected row and column readable
        // without tinting the white effectiveness cells.
        for (var _header_line = 0; _header_line < 4; _header_line++) {
            draw_rectangle(_hover_header_x + 1 + _header_line, _table_y + 1 + _header_line,
                _hover_header_x + _cell - 1 - _header_line, _table_y + _cell - 1 - _header_line, true);
            draw_rectangle(_table_x + 1 + _header_line, _hover_header_y + 1 + _header_line,
                _table_x + _cell - 1 - _header_line, _hover_header_y + _cell - 1 - _header_line, true);
        }

        // The exact intersection is one pixel heavier than its headers.
        for (var _cell_line = 0; _cell_line < 5; _cell_line++) {
            draw_rectangle(_hover_x + 1 + _cell_line, _hover_y + 1 + _cell_line,
                _hover_x + _cell - 1 - _cell_line, _hover_y + _cell - 1 - _cell_line, true);
        }
    }

    // Hover detail panel reduces row/column reading errors in the dense grid.
    var _detail_x1 = _table_x + _table_size + 28;
    var _detail_x2 = _x2 - 28;
    var _detail_y1 = _table_y + 30;
    var _detail_y2 = _detail_y1 + 274;
    ui_draw_panel(_detail_x1, _detail_y1, _detail_x2, _detail_y2, 10, _gold);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(Font6);
    draw_set_colour(_muted);
    draw_text(_detail_x1 + 18, _detail_y1 + 18, "선택한 상성");

    if (_hover_atk > 0 && _hover_def > 0) {
        var _detail_multiplier = global.typevs[_hover_atk][_hover_def];
        var _detail_result = "보통";
        var _detail_fill = _cell_fill;
        var _detail_symbol = _ink;
        if (_detail_multiplier == 2) {
            _detail_result = "강함";
            _detail_symbol = _strong_symbol;
        } else if (_detail_multiplier == 0.5) {
            _detail_result = "반감";
            _detail_symbol = _weak_symbol;
        } else if (_detail_multiplier == 0) {
            _detail_result = "무효";
            _detail_symbol = _immune_symbol;
        }

        draw_set_colour(merge_colour(pokemon_type_colour(_hover_atk), _ink, 0.18));
        draw_roundrect_ext(_detail_x1 + 16, _detail_y1 + 52,
            _detail_x2 - 16, _detail_y1 + 96, 6, 6, false);
        draw_set_font(Font5);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        ui_draw_text_outline((_detail_x1 + _detail_x2) * 0.5, _detail_y1 + 74,
            pokemon_type_name(_hover_atk) + " 공격", c_white, c_black);

        draw_set_colour(_muted);
        draw_set_font(Font6);
        draw_text((_detail_x1 + _detail_x2) * 0.5, _detail_y1 + 116, "VS");

        draw_set_colour(merge_colour(pokemon_type_colour(_hover_def), _ink, 0.18));
        draw_roundrect_ext(_detail_x1 + 16, _detail_y1 + 136,
            _detail_x2 - 16, _detail_y1 + 180, 6, 6, false);
        draw_set_font(Font5);
        ui_draw_text_outline((_detail_x1 + _detail_x2) * 0.5, _detail_y1 + 158,
            pokemon_type_name(_hover_def) + " 방어", c_white, c_black);

        draw_set_colour(_detail_fill);
        draw_rectangle(_detail_x1 + 54, _detail_y1 + 202,
            _detail_x1 + 99, _detail_y1 + 247, false);
        ui_draw_matchup_symbol(_detail_x1 + 76.5, _detail_y1 + 224.5,
            _detail_multiplier, _detail_symbol, _detail_fill);
        draw_set_halign(fa_left);
        draw_set_font(Font5);
        draw_set_colour(_ivory);
        draw_text(_detail_x1 + 112, _detail_y1 + 224, _detail_result);
    } else {
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_font(Font6);
        draw_set_colour(_muted);
        draw_text_ext((_detail_x1 + _detail_x2) * 0.5, _detail_y1 + 124,
            "상성 칸에 마우스를 올리면\n공격과 방어 타입을 확인할 수 있습니다",
            -1, _detail_x2 - _detail_x1 - 36);
    }

    // The click that opened the modal happened outside its page. Ignore that
    // physical click until release, then accept later outside clicks normally.
    if (modal_open_guard) {
        if (!mouse_check_button(mb_left)) modal_open_guard = false;
    } else if (mouse_check_button_pressed(mb_left)
        && !point_in_rectangle(_mx, _my, _x1, _y1, _x2, _y2)) {
        menu_opened = false;
    }

    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
