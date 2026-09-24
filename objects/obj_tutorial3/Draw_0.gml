// Rendering is centralized in obj_controller's existing Draw GUI event.
exit;

if(!instance_exists(obj_tutorial1) && !instance_exists(obj_tutorial2)){
	ui_draw_tutorial_bubble(600, 690, 340, 154, 3, "준비 완료", text_string,
		"START BATTLE을 클릭", button.x + 45, button.y, ui_colour("coral"), true);
}
