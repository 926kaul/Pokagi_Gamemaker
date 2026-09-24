depth = -2;
if (instance_number(object_index) > 1) {
	instance_destroy();
	exit;
}
flying_opened = false;
is_active = true; // 뮤츠 보유 여부 등에 따라 제어
