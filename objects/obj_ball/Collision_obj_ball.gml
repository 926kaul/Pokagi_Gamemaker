// ----------------------------------------
// 충돌 상대를 o라 하자
// ----------------------------------------
if(!moving) exit;
var o = other;

var typevs_result = global.typevs[stats.type1][o.stats.type1] * global.typevs[stats.type1][o.stats.type2] * global.typevs[stats.type2][o.stats.type1] * global.typevs[stats.type2][o.stats.type2];

var val1 = global.typevs[stats.type1][o.stats.type1];
var val2 = global.typevs[stats.type1][o.stats.type2];
var val3 = global.typevs[stats.type2][o.stats.type1];
var val4 = global.typevs[stats.type2][o.stats.type2];

show_debug_message("typevs : " + string(val1) + " " + string(val2) + " " + string(val3) + " " + string(val4));
show_debug_message("collision // v_x:" + string(velocity_x) + "v_y:" + string(velocity_y));

// 두 중심 사이 방향
var dx = x - o.x;
var dy = y - o.y;
var dist = point_distance(x, y, o.x, o.y);

// 완전히 같은 위치에서 충돌하면 정규화 과정에서 0으로 나누게 됩니다.
// 상대 속도를 우선 사용하고, 두 공 모두 정지한 경우에는 고정 축을 사용합니다.
if (dist <= 0.0001) {
	dx = velocity_x - o.velocity_x;
	dy = velocity_y - o.velocity_y;
	dist = point_distance(0, 0, dx, dy);
	if (dist <= 0.0001) {
		dx = 1;
		dy = 0;
		dist = 1;
	}
}

// 정규화된 노멀 벡터
var nx = dx / dist;
var ny = dy / dist;

// 상대 속도
var rvx = velocity_x - o.velocity_x;
var rvy = velocity_y - o.velocity_y;

// dot product (노멀 방향 상대 속도)
var dot = rvx * nx + rvy * ny;

// 서로 멀어지는 중이면 충돌 아님
if (dot > 0) exit;

// 무효 상성은 기존처럼 물리 충돌과 효과음을 적용하지 않습니다.
if (typevs_result == 0) exit;

// Play the SFX only for a real, approaching impact. Previously it played
// before the separating check above, which made some sounds feel one beat late.
var _impact_speed = -dot;
if (_impact_speed >= 0.35
    && current_turn
    && current_time >= global.next_collision_sound_time) {
    global.next_collision_sound_time = current_time + 160;
    if (typevs_result >= 4) audio_play_sound(alt_effective, 20, false);
    else if (typevs_result >= 2) audio_play_sound(effective, 15, false);
    else if (typevs_result <= 0.25) audio_play_sound(alt_weak, 1, false);
    else if (typevs_result <= 0.5) audio_play_sound(weak, 5, false);
    else audio_play_sound(normal, 10, false);
}

// ----------------------------------------
// 🔥 moving 상태에 따른 유효질량 적용
// ----------------------------------------
var m1 = (moving ? stats.mass_move : stats.mass_stop);
var m2 = (o.moving ? o.stats.mass_move : o.stats.mass_stop);

// ----------------------------------------
// 완전탄성 충돌 impulse 계산
// ----------------------------------------

var e = 1.0; // 탄성계수 (완전탄성)
var j = -(1 + e) * dot;
j /= (1/m1 + 1/m2);   // 질량이 다르면 여기가 달라짐

// 속도 변경
velocity_x += (j / m1) * nx;
velocity_y += (j / m1) * ny;

o.velocity_x -= (j / m2) * nx * typevs_result;
o.velocity_y -= (j / m2) * ny * typevs_result;

// 현재 속도 벡터의 크기 계산
var _o_current_speed = point_distance(0, 0, o.velocity_x, o.velocity_y);

// 속도 상한이 필요하다면
if (_o_current_speed > 39) {
    // 속도 벡터를 최대 속도로 정규화 및 스케일링
    
    // 1. 방향 벡터를 계산 (정규화)
    var _o_dir_x = o.velocity_x / _o_current_speed;
    var _o_dir_y = o.velocity_y / _o_current_speed;
    
    // 2. 최대 속도를 곱하여 상한을 적용
    o.velocity_x = _o_dir_x * 39;
    o.velocity_y = _o_dir_y * 39;

}

// 둘 다 moving 시작
moving = true;
o.moving = true;



// ----------------------------------------
// ✨ 메타몽 변신 로직 추가 (pokemon_id 132)
// ----------------------------------------
if (pokemon_id == 132) {
    // 1. 자신의 ID를 상대방의 ID로 변경합니다.
    pokemon_id = o.pokemon_id;
}
if (o.pokemon_id == 132) {
    // 1. 자신의 ID를 상대방의 ID로 변경합니다.
    o.pokemon_id = pokemon_id;
}
