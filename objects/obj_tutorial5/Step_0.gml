var _tutorial4_ready = true;
if (instance_exists(obj_tutorial4)) {
    _tutorial4_ready = obj_tutorial4.next_guide_ready;
}

if (_tutorial4_ready && obj_controller.battle_ready) {
    var _ball_count = array_length(obj_controller.balls);
    if (obj_controller.state == BattleState.PLAYER_INPUT && _ball_count > 0) {
        var _index = clamp(obj_controller.turn_index, 0, _ball_count - 1);
        var _current = obj_controller.balls[_index];
        if (instance_exists(_current) && team_is_player(_current.owner)) {
            seen_player_input = true;
        }
    }

    if (seen_player_input && obj_controller.state == BattleState.MOVING) {
        with (obj_tutorial4) instance_destroy();
        instance_destroy();
    }
}
