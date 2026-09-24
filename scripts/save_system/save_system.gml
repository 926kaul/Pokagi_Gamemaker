function profile_is_caught(_pokemon_id) {
    var _profile = instance_find(obj_mypokemon, 0);
    return instance_exists(_profile) && _profile.my_pokes[_pokemon_id - 1] == 1;
}

function profile_catch(_pokemon_id) {
    var _profile = instance_find(obj_mypokemon, 0);
    if (!instance_exists(_profile) || _pokemon_id < 1 || _pokemon_id > 151) return false;
    if (_profile.my_pokes[_pokemon_id - 1] == 1) return false;
    _profile.my_pokes[_pokemon_id - 1] = 1;
    save_my_pokes();
    return true;
}

function profile_evolve(_pokemon_id) {
    if (!global.evol[_pokemon_id - 1]) return false;
    return profile_catch(_pokemon_id + 1);
}

function profile_has_completed_kanto() {
    var _profile = instance_find(obj_mypokemon, 0);
    if (!instance_exists(_profile)) return false;
    for (var _i = 0; _i < 150; _i++) {
        if (_profile.my_pokes[_i] != 1) return false;
    }
    return true;
}
