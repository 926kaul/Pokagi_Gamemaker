// --- Draw Event ---
if(!obj_controller.selection_done){
    draw_set_font(text_font);

    // 1. 도감 완성 여부 체크 (기존 로직 유지)
    var _all_caught = true;
    for (var i = 0; i < 150; i++) { 
        if (obj_mypokemon.my_pokes[i] != 1) {
            _all_caught = false;
            break; 
        }
    }

    // 2. 상황에 맞는 텍스트 선택
    var _target_text = "";
	if(_all_caught) _target_text = text_string_dex_end;
    else if(obj_mypokemon.my_pokes[149] == 1) _target_text = text_string_real_end;
	else if(global.endclear) _target_text = text_string_end;
    else  _target_text = text_string;

    // 3. 텍스트 높이 계산 (자동 줄바꿈 반영)
    // 지정된 box_width 내에서 텍스트가 차지할 실제 높이를 계산
    var _text_h = string_height_ext(_target_text, line_sep, box_width);
    
    // 배경의 최종 크기
    var _bg_w = box_width + (bg_padding * 2);
    var _bg_h = _text_h + (bg_padding * 2);

    // 4. 배경 시작 좌표 계산 (정렬 기준)
    var _bg_x1 = x;
    var _bg_y1 = y;

    if (text_halign == fa_center) _bg_x1 -= _bg_w / 2;
    else if (text_halign == fa_right) _bg_x1 -= _bg_w;

    if (text_valign == fa_middle) _bg_y1 -= _bg_h / 2;
    else if (text_valign == fa_bottom) _bg_y1 -= _bg_h;

    // 5. 배경 그리기 (포스트잇)
    draw_set_color(bg_color);
    draw_rectangle(_bg_x1, _bg_y1, _bg_x1 + _bg_w, _bg_y1 + _bg_h, false);
    
    // 테두리 추가 (가독성을 위해 검은색 얇은 테두리)
    draw_set_color(c_black);
    draw_rectangle(_bg_x1, _bg_y1, _bg_x1 + _bg_w, _bg_y1 + _bg_h, true);

    // 6. 텍스트 그리기
    draw_set_color(text_color);
    draw_set_halign(fa_left); // 상자 내부 텍스트는 좌측 정렬 고정
    draw_set_valign(fa_top);
    
    // draw_text_ext를 사용하여 자동 줄바꿈 적용 출력
    draw_text_ext(_bg_x1 + bg_padding, _bg_y1 + bg_padding, _target_text, line_sep, box_width);
}