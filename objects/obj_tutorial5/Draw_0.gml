// Rendering is centralized in obj_controller's existing Draw GUI event.
exit;

if(!instance_exists(obj_tutorial3) && !instance_exists(obj_tutorial4)){
	var _target_x = global.board.center_x;
	var _target_y = global.board.player_top + 120;
	var _ball_count = array_length(obj_controller.balls);
	if (_ball_count > 0) {
		var _index = clamp(obj_controller.turn_index, 0, _ball_count - 1);
		var _current = obj_controller.balls[_index];
		if (instance_exists(_current)) {
			_target_x = _current.x;
			_target_y = _current.y;
		}
	}
	ui_draw_tutorial_bubble(976, 230, 288, 220, 5, "당겨서 발사", text_string,
		"최대 당김 거리 · 5칸", _target_x, _target_y, ui_colour("cyan"), true);
}
