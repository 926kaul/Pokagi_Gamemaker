// obj_controller의 Draw GUI 이벤트
draw_set_font(Font2);
draw_set_halign(fa_left);
draw_set_valign(fa_bottom);
draw_set_color(c_white); // 표시할 색상 설정

// 화면 해상도를 가져옵니다.
var _screen_width = display_get_gui_width();
var _screen_height = display_get_gui_height();

// 왼쪽 하단에 텍스트 그리기
// x: 화면 왼쪽에서 조금 떨어진 위치 (예: 20픽셀)
// y: 화면 하단에서 조금 떨어진 위치 (예: _screen_height - 20)
draw_text(20, _screen_height - 20, global.stage_display_text);

// (옵션) 설정 초기화
draw_set_halign(fa_left);
draw_set_valign(fa_top);


// obj_controller Draw GUI Event

// 1. GUI 기본 크기 가져오기
var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

// 2. 볼륨 바 전용 변수 (이름 뒤에 _vol을 붙여서 구분!)
var _vol_bar_w = 150; 
var _vol_bar_h = 10;
var _vol_padding = 40;

// 3. 우측 하단 좌표 계산
var _vol_draw_x = _gui_w - _vol_bar_w - _vol_padding;
var _vol_draw_y = _gui_h - _vol_bar_h - _vol_padding - 20;

var _master_vol = global.master_volume;

// --- 볼륨 바 그리기 ---

// 1. 테두리 (배경)
draw_set_color(c_black);
draw_rectangle(_vol_draw_x, _vol_draw_y, _vol_draw_x + _vol_bar_w, _vol_draw_y + _vol_bar_h, true); 

// 2. 채우기 (레벨)
draw_set_color(c_lime); 
var _vol_fill_w = _vol_bar_w * _master_vol; 
draw_rectangle(_vol_draw_x, _vol_draw_y, _vol_draw_x + _vol_fill_w, _vol_draw_y + _vol_bar_h, false); 

// 3. 텍스트
draw_set_font(Font3);
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_text(_vol_draw_x + _vol_bar_w / 2, _vol_draw_y + _vol_bar_h + 5, "Volume: " + string(round(_master_vol * 100)) + "%");



// ----------------------------------------
// ✨ Generation 숫자 표기 추가
// ----------------------------------------
draw_set_font(Font4); 
draw_set_color(c_white);
draw_set_halign(fa_left); // 왼쪽 정렬
draw_set_valign(fa_top);  // 위쪽 정렬

var _gen_count = string(generation);
var _gen_text = "GEN " + _gen_count;
if(generation > 5) _gen_text += "\nLESS FRICTION!"

/// ----------------------------------------
/// Turn Order UI
/// ----------------------------------------

var ui_x = 140;
var ui_y = 60;
var offset_x = 40;

draw_text(ui_x - 100, ui_y, _gen_text);

var len = array_length(balls);

// balls가 비었으면 UI 없음
if (len <= 0) exit;

// turn_index 검사
var start_i = turn_index;
if (start_i < 0) start_i = 0;
if (start_i >= len) start_i = len - 1;


if (state == "enemy_win") {
	draw_set_font(Font1);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(room_width/2, room_height/2, "GAME\n\nOVER");
}

else if (state == "player_win") {
	draw_set_font(Font1);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(room_width/2, room_height/2, "YOU WIN!");
}
else if(battle_ready){
	// turn_index부터 끝까지 UI 표시
	for (var i = start_i; i < len; i++)
	{
	    var b = balls[i];

	    // Instance가 죽었는지 확인
	    if (!instance_exists(b)) continue;

	    // 그리는 위치
	    var draw_x = ui_x + (i - start_i) * offset_x;
	    var draw_y = ui_y;

	    // ball 스프라이트 그대로 / 0.5 스케일
	    draw_sprite_ext(b.sprite_index, b.image_index,
	        draw_x, draw_y,
	        0.5, 0.5,
	        0, c_white, 1);
		if(b.owner == "enemy"){
			draw_sprite_ext(b.sprite_index, b.image_index,
	        draw_x, draw_y,
	        0.5, 0.5,
	        0, make_colour_rgb(255, 191, 191), 1);
		}
		else{
			draw_sprite_ext(b.sprite_index, b.image_index,
	        draw_x, draw_y,
	        0.5, 0.5,
	        0, c_white, 1);	
		}
	}
}



