if (settings_opened) {
    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();
    var _ivory = ui_colour("ivory");
    var _muted = ui_colour("muted");
    var _ink = ui_colour("ink");
    var _gold = ui_colour("gold");
    var _divider = make_colour_rgb(47, 58, 65);

    var _page_w = 620;
    var _page_h = 360;
    var _x1 = (_gui_w - _page_w) * 0.5;
    var _y1 = (_gui_h - _page_h) * 0.5;
    var _x2 = _x1 + _page_w;
    var _y2 = _y1 + _page_h;

    draw_set_alpha(0.8);
    draw_set_colour(_ink);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
    draw_set_alpha(1);
    ui_draw_panel(_x1, _y1, _x2, _y2, 16, _gold);

    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_set_font(Font5);
    draw_set_colour(_ivory);
    draw_text(_x1 + 34, _y1 + 38, "설정");
    draw_set_font(Font6);
    draw_set_colour(_muted);
    draw_text(_x1 + 34, _y1 + 66, "게임 환경");

    var _card_x1 = _x1 + 34;
    var _card_y1 = _y1 + 104;
    var _card_x2 = _x2 - 34;
    var _card_y2 = _y2 - 42;
    ui_draw_panel(_card_x1, _card_y1, _card_x2, _card_y2, 10, _gold);

    draw_set_font(Font5);
    draw_set_colour(_ivory);
    draw_text(_card_x1 + 24, _card_y1 + 34, "전체 음량");
    draw_set_halign(fa_right);
    draw_set_colour(_gold);
    draw_text(_card_x2 - 24, _card_y1 + 34, string(round(global.master_volume * 100)) + "%");

    draw_set_halign(fa_left);
    draw_set_font(Font6);
    draw_set_colour(_muted);
    draw_text(_card_x1 + 24, _card_y1 + 66, "게임의 모든 효과음에 적용됩니다.");

    var _bar_x = _x1 + 150;
    var _bar_y = _y1 + 205;
    // The GUI and room share the same 1600x960 logical space. mouse_x/y stay
    // correct when HTML5 uses a DPR-sized backing store.
    var _mouse_x = mouse_x;
    var _mouse_y = mouse_y;
    var _bar_hover = point_in_rectangle(
        _mouse_x, _mouse_y,
        _bar_x - 10, _bar_y - 14,
        _bar_x + volume_bar_width + 10, _bar_y + volume_bar_height + 14
    );
    var _bar_accent = (_bar_hover || volume_dragging) ? _ivory : _gold;

    draw_set_colour(_divider);
    draw_roundrect_ext(_bar_x, _bar_y,
        _bar_x + volume_bar_width, _bar_y + volume_bar_height, 7, 7, false);
    draw_set_colour(_bar_accent);
    draw_roundrect_ext(_bar_x, _bar_y,
        _bar_x + volume_bar_width * global.master_volume,
        _bar_y + volume_bar_height, 7, 7, false);
    draw_circle(
        _bar_x + volume_bar_width * global.master_volume,
        _bar_y + volume_bar_height * 0.5,
        (_bar_hover || volume_dragging) ? 10 : 8,
        false
    );

    draw_set_font(Font6);
    draw_set_colour(_muted);
    draw_set_halign(fa_left);
    draw_text(_bar_x, _bar_y + 38, "0");
    draw_set_halign(fa_right);
    draw_text(_bar_x + volume_bar_width, _bar_y + 38, "100");

    // Ignore the physical click that opened the page, then allow later
    // outside clicks to close it without affecting slider interaction.
    if (modal_open_guard) {
        if (!mouse_check_button(mb_left)) modal_open_guard = false;
    } else if (mouse_check_button_pressed(mb_left)
        && !point_in_rectangle(_mouse_x, _mouse_y, _x1, _y1, _x2, _y2)) {
        settings_opened = false;
        volume_dragging = false;
    }

    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
