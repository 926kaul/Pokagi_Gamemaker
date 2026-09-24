// Rendering is centralized in obj_controller's existing Draw GUI event.
exit;

if(!instance_exists(obj_tutorial1)){
	var _open = obj_mypokemon.pokeball_opened;
	var _target_x = _open ? obj_mypokemon.collection_grid_x : obj_mypokemon.x + 32;
	var _target_y = _open ? obj_mypokemon.collection_grid_y : obj_mypokemon.y + 32;
	var _body = obj_mypokemon.my_pokes[149] != 1 ? text_string : text_string_real_end;
	var _hint = _open ? "최대 3마리" : "오른쪽 아래 버튼을 클릭";
	if (_open) {
		// Align the right-hand tail directly with the first collection row.
		ui_draw_tutorial_bubble(600, 140, 340, 178, 2, "팀을 꾸려볼까요?", _body, _hint,
			_target_x, _target_y, ui_colour("cyan"), true);
	} else {
		// Sit inside the rail so the bottom tail points at the collection button.
		ui_draw_tutorial_bubble(976, 490, 288, 230, 2, "팀을 꾸려볼까요?", _body, _hint,
			_target_x, _target_y, ui_colour("cyan"), true);
	}
}
