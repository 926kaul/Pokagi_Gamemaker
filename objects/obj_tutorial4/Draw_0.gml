// Rendering is centralized in obj_controller's existing Draw GUI event.
exit;

if(!instance_exists(obj_tutorial3)){
	var _all_caught = true;
    for (var i = 0; i < 150; i++) { 
        if (obj_mypokemon.my_pokes[i] != 1) {
            _all_caught = false;
            break; 
        }
    }

    var _target_text = _all_caught ? text_string_dex_end : text_string;
	ui_draw_tutorial_bubble(490, 142, 440, 154, 4, "라운드와 턴 순서", _target_text,
		"상단 아이콘은 왼쪽부터 진행", 780, 72, ui_colour("gold"), true);
}
