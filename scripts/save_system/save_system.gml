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

function profile_load_champion() {
    var _save_key = "champion_clear_v1";
    if (file_exists(_save_key)) {
        var _file = file_text_open_read(_save_key);
        var _value = file_text_read_string(_file);
        file_text_close(_file);
        return _value == "1";
    }

    // Before champion progress had its own flag, owning Mewtwo was the only
    // way to unlock Fly and therefore proves this legacy profile cleared the
    // champion route. Preserve that unlock during the one-time migration.
    if (profile_is_caught(150)) {
        var _legacy_file = file_text_open_write(_save_key);
        file_text_write_string(_legacy_file, "1");
        file_text_close(_legacy_file);
        return true;
    }

    return false;
}

function profile_set_champion() {
    global.endclear = true;
    var _save_key = "champion_clear_v1";
    var _file = file_text_open_write(_save_key);
    file_text_write_string(_file, "1");
    file_text_close(_file);
}
