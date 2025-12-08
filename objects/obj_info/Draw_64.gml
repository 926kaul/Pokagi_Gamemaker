draw_self();

if(info_opened){
	
	// 네모 창의 좌표와 크기
	var _x1 = 80;
	var _y1 = 40;
	var _x2 = 880;
	var _y2 = 400;

    draw_set_colour(make_colour_rgb(32, 32, 96));

	// 사각형 그리기
	draw_roundrect_ext(_x1, _y1, _x2, _y2, 20, 20, false); // false는 채우기 (true는 윤곽선만)
	
	// ----------------------------------------
    // 2. 상성표 스프라이트 그리기 (스케일 적용)
    // ----------------------------------------
    
    var _chart_sprite = typevs_sprite; 
    var _scale = 0.5; // 스케일 값을 0.5로 설정
    
    // 스프라이트의 원래 크기를 스케일링하여 표시될 크기 계산
    var _chart_scaled_width = sprite_get_width(_chart_sprite) * _scale; 
    
    var _window_center_x = (_x1 + _x2) / 2; 
    
    // 스케일링된 크기를 사용하여 중앙 배치 계산
    var _chart_x = _x1 + 40;
    var _chart_y = _y1 + 40; 
    
    // draw_sprite_ext 함수 사용
    draw_sprite_ext(
        _chart_sprite, // 스프라이트 리소스
        0,             // 이미지 인덱스 (0)
        _chart_x,      // X 좌표
        _chart_y,      // Y 좌표
        _scale,        // X 스케일 (0.5)
        _scale,        // Y 스케일 (0.5)
        0,             // 회전 각도 (0)
        c_white,       // 블렌드 색상 (없음)
        1              // 알파값 (1.0)
    );

    // ----------------------------------------
    // 3. 설명 텍스트 추가
    // ----------------------------------------
    
    var _text_x = 480;
    var _text_y = 60;
    
	var _max_width = 380;    // Max width for wrapping (860 - 480)

	draw_set_font(Font4);
	draw_set_color(c_white); 
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
    
	var _info_text_en = 
	    "1. Velocity after collisions is linked to Type Effectiveness. Crucially, both Type 1 and Type 2 of the two colliding Pokemon are fully reflected in this calculation (Gen 1 Type Chart).\n\n" +
	    "2. A Pokemon's Size is determined by its original HP, Moving Mass by Attack/Special, Static Mass by Defense/Special, and Max Speed by Speed.\n\n" +
	    "3. Defeated enemy Pokemon are registered in the Pokedex and become available for use. Surviving allied Pokemon may evolve upon winning a battle.\n\n" +
	    "4. A Hidden Stage may be unlocked if you win a stage with all three allied Pokemon surviving.\n\n" +
		"5. There will be less friction from Gen 6 for speedy game.\n\n" +
	    "6. For more detailed information, please visit my GitHub page.";
                 
	// Use string_wrap_ext to automatically insert line breaks at 380px width.
	draw_text_ext(480, 60, _info_text_en, -1, _max_width);
	
	// ----------------------------------------
    // 4. ✨ 하이퍼링크 아이콘 그리기 (스케일 0.2 적용)
    // ----------------------------------------

    var _padding = 20;
    _scale = 0.2;

    // ✨ 스케일링된 크기 계산
    var _icon_width = sprite_get_width(link_sprite) * _scale;
    var _icon_height = sprite_get_height(link_sprite) * _scale;
    var _link_x = _x2 - _padding - _icon_width;
    var _link_y = _y2 - _padding - _icon_height;
    
    // a) 색상 및 커서 변경 (Hover 상태에 따라)
    var _draw_color = c_white;
    if (link_is_hovered) {
        _draw_color = make_colour_rgb(200, 200, 255); 
        window_set_cursor(cr_handpoint); 
    } else {
        window_set_cursor(cr_default); 
    }

    // b) 아이콘 그리기 (draw_sprite_ext에 _scale 적용)
    draw_sprite_ext(
        link_sprite, // 아이콘 스프라이트
        0,           
        _link_x,     
        _link_y,     
        _scale,      // ✨ 0.2 적용
        _scale,      // ✨ 0.2 적용
        0,           
        _draw_color, 
        1            
    );
    
}

