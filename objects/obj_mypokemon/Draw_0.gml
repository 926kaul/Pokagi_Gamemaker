draw_self();

if(pokeball_opened && !obj_controller.battle_ready){
	
	// 네모 창의 좌표와 크기
	var _x1 = 80;
	var _y1 = 40;
	var _x2 = 880;
	var _y2 = 400;

	// 연노란색 (RGB: 255, 255, 224 또는 적절한 연노란색)

	// c_yellow는 밝은 노란색이므로, 연노란색을 위해 직접 색상을 지정할 수도 있습니다.
    draw_set_colour(make_colour_rgb(192, 192, 128)); // 예: 연노랑

	// 반투명하게 하고 싶다면
	// draw_set_alpha(0.8); // 80% 불투명도

	// 사각형 그리기
	draw_roundrect_ext(_x1, _y1, _x2, _y2, 20, 20, false); // false는 채우기 (true는 윤곽선만)
	
}