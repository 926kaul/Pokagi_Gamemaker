depth = -2;
if (instance_number(object_index) > 1) {
	instance_destroy();
	exit;
}
menu_opened = false; // 상성표 창 제어 변수
modal_open_guard = false;
x = room_width - 72;
y = 24;
