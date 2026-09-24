depth = -2;
if (instance_number(object_index) > 1) {
	instance_destroy();
	exit;
}
flying_opened = false;
modal_open_guard = false;
is_active = false; // 뮤츠 보유 여부 등에 따라 제어
x = room_width - 72;
y = 682;
