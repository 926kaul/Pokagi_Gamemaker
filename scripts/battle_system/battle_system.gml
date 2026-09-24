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
