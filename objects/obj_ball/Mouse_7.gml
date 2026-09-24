// ------------------------------
// (A) 배치 드래그 끝
// ------------------------------
if (is_placing && team_is_player(owner)) {
    is_placing = false;

    // 바둑판 스냅
    var gx = clamp(mouse_x, global.board.left, global.board.right);
    var gy = clamp(mouse_y, global.board.top, global.board.bottom);
    gx = board_snap(gx, global.board.left);
    gy = board_snap(gy, global.board.top);

	// Preview and release share the same occupancy helper. The stage-wide
	// deployment counter does not decrease when a Pokemon is knocked out.
	var position_free = board_position_is_free(gx, gy, id);
	var deployments_used = max(obj_controller.player_deployments_used, board_player_placed_count());
	var deployment_slot_free = deployments_used < 3;

    // 아래 절반만 허용
    if (board_is_player_area(mouse_y) && deployment_slot_free && position_free) {
        x = gx;
        y = gy;
        placed = true;
		depth = 0;
		obj_controller.player_deployments_used = deployments_used + 1;

		// Pokemon deployed after START must join the live turn order as well.
		if (obj_controller.turn_system_started) {
			array_push(obj_controller.balls, id);
		}
		
    } else {
        // Collection icons always return to their exact grid slot. Keeping a
        // dedicated home coordinate prevents drag event ordering from
        // overwriting the return point with an intermediate mouse position.
        x = has_collection_home ? collection_home_x : original_x;
        y = has_collection_home ? collection_home_y : original_y;
    }
}

