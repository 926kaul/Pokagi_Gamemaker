/// Stage progression is deliberately data-driven even while the legacy rooms remain.
function stage_get_next_room(_room, _perfect_clear) {
    switch (_room) {
        case Room1: return Room2;
        case Room2: return Room2_1;
        case Room2_1: return Room3;
        case Room3: return Room3_1;
        case Room3_1: return Room4;
        case Room4: return Room4_1;
        case Room4_1: return Room5;
        case Room5: return _perfect_clear ? Room5_2 : Room5_1;
        case Room5_1:
        case Room5_2: return Room6;
        case Room6: return Room6_1;
        case Room6_1: return Room7;
        case Room7: return Room7_1;
        case Room7_1: return Room8;
        case Room8: return _perfect_clear ? Room8_2 : Room8_1;
        case Room8_1:
        case Room8_2: return Room9;
        case Room9: return _perfect_clear ? Room9_2 : Room9_1;
        case Room9_1:
        case Room9_2: return Room10;
        case Room10: return RoomFinal;
        case RoomFinal: return _perfect_clear ? RoomReal_Final : Room1;
        case RoomReal_Final: return Room1;
    }
    return noone;
}

function stage_get_random_enemy_config(_room) {
    switch (_room) {
        case Room2_1: return { ids: [10, 13, 16, 19, 21, 23], count: 2 };
        case Room3_1: return { ids: [27, 29, 32, 35, 37, 39, 41, 43, 46, 48], count: 3 };
        case Room4_1: return { ids: [50, 52, 56, 58, 60, 63, 66, 69, 72], count: 3 };
        case Room6_1: return { ids: [77, 79, 83, 84, 86, 88, 90, 92, 96, 98], count: 3 };
        case Room7_1: return { ids: [102, 104, 106, 107, 108, 111, 113, 115, 116], count: 3 };
        case Room8_1: return { ids: [118, 120, 123, 124, 125, 127, 128, 129, 131], count: 3 };
        case Room8_2: return { ids: [137, 138, 140, 142, 143], count: 3 };
    }
    return undefined;
}

function stage_update_display(_room) {
    var _name = room_get_name(_room);
    var _stage = string_replace(_name, "Room", "");
    var _parts = string_split(_stage, "_");
    global.current_stage_main = _parts[0];
    global.current_stage_sub = array_length(_parts) > 1 ? _parts[1] : "";
    global.stage_display_text = "Stage " + global.current_stage_main;
    if (global.current_stage_sub != "") global.stage_display_text += " - " + global.current_stage_sub;
}
