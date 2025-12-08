if(!instance_exists(obj_tutorial1)){
	// obj_text Draw Event

	// 폰트 설정 (이벤트 상단에 있어야 크기 계산에 사용됨)
	draw_set_font(text_font);
	draw_set_halign(text_halign);
	draw_set_valign(text_valign);

	// ----------------------------------------
	// 1. 배경 사각형 (포스트잇) 그리기
	// ----------------------------------------

	var _text_w = string_width(text_string);
	var _text_h = string_height(text_string);

	// 배경의 최종 크기
	var _bg_w = _text_w + (bg_padding * 2);
	var _bg_h = _text_h + (bg_padding * 2);

	// 배경의 시작 좌표 (텍스트의 정렬(align)에 따라 조정)
	var _bg_x1 = x;
	var _bg_y1 = y;

	// 텍스트 정렬에 따라 배경 시작 좌표 조정
	if (text_halign == fa_center) {
	    _bg_x1 -= _bg_w / 2;
	} else if (text_halign == fa_right) {
	    _bg_x1 -= _bg_w;
	}

	if (text_valign == fa_middle) {
	    _bg_y1 -= _bg_h / 2;
	} else if (text_valign == fa_bottom) {
	    _bg_y1 -= _bg_h;
	}

	// 배경 그리기
	draw_set_color(bg_color);
	draw_rectangle(_bg_x1, _bg_y1, _bg_x1 + _bg_w, _bg_y1 + _bg_h, false); // false: 채우기


	// ----------------------------------------
	// 2. 텍스트 그리기
	// ----------------------------------------

	// 텍스트 시작 좌표 (배경 사각형 안에 여백만큼 이동)
	var _text_draw_x = _bg_x1 + bg_padding;
	var _text_draw_y = _bg_y1 + bg_padding;

	// 텍스트 색상 설정
	draw_set_colour(text_color);

	// 텍스트 정렬을 무시하고, 배경 여백을 기준으로 왼쪽 상단부터 그립니다.
	draw_set_halign(fa_left); 
	draw_set_valign(fa_top);

	draw_text(_text_draw_x, _text_draw_y, text_string);
}
