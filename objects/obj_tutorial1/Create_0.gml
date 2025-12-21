// --- Create Event ---
text_string = "1. 바깥은 혼자 돌아다니기엔 위험하단다!\n이 아이들 중 하나를 데려가렴";
text_string_end = "이겼구나! 축하한다!\n네가 새로운 포켓몬 리그의 챔피언이다!\n전설의 포켓몬은 없지만...";
text_string_real_end = "이겼구나! 축하한다!\n네가 새로운 포켓몬 리그의 챔피언이자 전설이다!\n도감은 남았지만...";
text_string_dex_end = "오오! 드디어 도감을 완성했구나!\n정말 축하한다!\n이 아이들을 자세히 보렴."

text_color = c_black;
text_font = Font5; 
text_halign = fa_left;
text_valign = fa_top;

bg_color = make_colour_rgb(255, 255, 128); 
bg_padding = 10; // 여백을 조금 늘렸습니다.

// --- 추가된 설정 변수 ---
box_width = 380; // 포스트잇의 가로 너비 (이 너비를 넘어가면 자동 줄바꿈)
line_sep = -1;   // 줄 간격 (-1은 폰트 기본값)