sprite_index = Pokemon;
image_speed = 0;
base_image_scale = 40 / sprite_get_width(sprite_index);
image_xscale = base_image_scale;
image_yscale = base_image_scale;

// 배치 드래그
is_placing = false;
placed = false;           // 바둑판 위에 올려진 상태

// 샷 드래그
is_shooting = false;
moving = false;

// 발사 계산에 필요
pull_start_x = 0;
pull_start_y = 0;

velocity_x = 0;
velocity_y = 0;

// 턴 관련
current_turn = false;

original_x = x;
original_y = y;

//탈락 관련
is_dead = false;

var stats;

trail = [];
trail_length = 30; // 최근 30프레임 궤적
