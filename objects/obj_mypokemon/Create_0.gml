my_pokes = array_create(151, 0);
load_my_pokes();

// This menu owns the top-most GUI drawer when opened.
depth = -100000;

pokeball_opened = false;
inspected_pokemon_id = 0;
x = room_width - 104;
y = 760;

// Collection screen geometry inside the permanent right command rail.
pokemon_info_panel_x1 = 28;
pokemon_info_panel_y1 = 126;
pokemon_info_panel_x2 = 300;
pokemon_info_panel_y2 = 620;
collection_panel_x1 = room_width - 300;
collection_panel_y1 = 126;
collection_panel_x2 = room_width - 28;
collection_panel_y2 = 620;
collection_grid_x = collection_panel_x1 + 22;
collection_grid_y = 218;
collection_grid_columns = 10;
collection_grid_step_x = 25;
collection_grid_step_y = 25;
collection_icon_size = 22;

create_pokeball_instances = function() {
    for (var i = 0; i < 151; i++) {
        if (my_pokes[i] != 0) {
            var _col_index = i % collection_grid_columns;
            var _row_index = floor(i / collection_grid_columns);
            var _x = collection_grid_x + (_col_index * collection_grid_step_x);
            var _y = collection_grid_y + (_row_index * collection_grid_step_y);
            var _ball_inst = instance_create_layer(_x, _y, "Instances", obj_ball);

            _ball_inst.pokemon_id = i + 1;
			_ball_inst.owner = "player";
			_ball_inst.depth = -5;
			var _collection_scale = collection_icon_size / sprite_get_width(_ball_inst.sprite_index);
			_ball_inst.image_xscale = _collection_scale;
			_ball_inst.image_yscale = _collection_scale;
        }
    }
};

clear_pokeball_instances = function(){
	with (obj_ball) {
	    if (team_is_player(owner) && !placed) {
	        instance_destroy();
	    }
	}
};
