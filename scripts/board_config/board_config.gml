function board_config_initialize() {
    global.board = {
        left: 120,
        top: 120,
        right: 840,
        bottom: 840,
        center_x: 480,
        center_y: 480,
        player_top: 480,
        grid_size: 40,
        max_pull: 200
    };
}

function board_is_inside(_x, _y) {
    return _x >= global.board.left && _x <= global.board.right
        && _y >= global.board.top && _y <= global.board.bottom;
}

function board_is_player_area(_y) {
    return _y >= global.board.player_top && _y <= global.board.bottom;
}

function board_snap(_value, _minimum) {
    return _minimum + round((_value - _minimum) / global.board.grid_size) * global.board.grid_size;
}

function board_position_is_free(_x, _y, _ignore_id) {
    var _free = true;
    with (obj_ball) {
        if (id != _ignore_id && placed && x == _x && y == _y) {
            _free = false;
        }
    }
    return _free;
}

function board_player_placed_count() {
    var _count = 0;
    with (obj_ball) {
        if (placed && team_is_player(owner)
            && board_is_inside(x, y) && board_is_player_area(y)) {
            _count++;
        }
    }
    return _count;
}

function board_distance_from_center(_instance) {
    return point_distance(_instance.x, _instance.y, global.board.center_x, global.board.center_y);
}
