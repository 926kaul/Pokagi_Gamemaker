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
var _x = 750;
var _y = 890;
var _w = 100;
var _h = 10;
var _vol = global.master_volume;

// 1. 볼륨 바의 배경 (테두리) 그리기
draw_set_color(c_black);
draw_rectangle(_x, _y, _x + _w, _y + _h, true); // true: 외곽선만

// 2. 현재 볼륨 레벨(채워진 부분) 그리기
draw_set_color(c_lime); // 채울 색상
var _fill_width = _w * _vol; // 현재 볼륨 비율에 따른 채워진 너비
draw_rectangle(_x, _y, _x + _fill_width, _y + _h, false); // false: 채우기

// 3. (선택 사항) 텍스트 표시
draw_set_font(Font3);
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_text(_x + _w / 2, _y + _h + 5, "Volume: " + string(round(_vol * 100)) + "%");



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



