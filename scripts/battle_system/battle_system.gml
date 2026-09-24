function battle_start(_controller) {
    with (_controller) {
        start_turn_system();
        turn_system_started = true;
    }
}

function battle_process_victory(_controller) {
    with (_controller) {
        player_cnt = 0;
        for (var _i = 0; _i < array_length(balls); _i++) {
            var _ball = balls[_i];
            if (instance_exists(_ball) && team_is_player(_ball.owner)) {
                player_cnt++;
                profile_evolve(_ball.pokemon_id);
            }
        }

        if (room == RoomFinal) global.endclear = true;
        var _next_room = stage_get_next_room(room, player_cnt >= 3);
        if (_next_room != noone) room_goto(_next_room);
        state = BattleState.WAIT_TURN;
    }
}

function battle_update_volume(_controller) {
    with (_controller) {
        var _gui_w = display_get_gui_width();
        var _gui_h = display_get_gui_height();
        var _bar_w = 150;
        var _bar_h = 10;
        var _padding = 40;
        var _x = _gui_w - _bar_w - _padding;
        var _y = _gui_h - _bar_h - _padding - 20;
        var _mouse_x = device_mouse_x_to_gui(0);
        var _mouse_y = device_mouse_y_to_gui(0);

        if (mouse_check_button(mb_left)
        && _mouse_x >= _x && _mouse_x <= _x + _bar_w
        && _mouse_y >= _y && _mouse_y <= _y + _bar_h) {
            global.master_volume = clamp((_mouse_x - _x) / _bar_w, 0, 1);
            set_master_volume(global.master_volume * 0.5);
        }
    }
}
