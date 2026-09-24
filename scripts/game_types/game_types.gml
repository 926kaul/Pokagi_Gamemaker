/// Shared, compiler-checked values used by the game.
enum Team {
    NONE,
    PLAYER,
    ENEMY
}

enum BattleState {
    IDLE,
    WAIT_TURN,
    PLAYER_INPUT,
    ENEMY_ACTION,
    MOVING,
    END_TURN,
    PLAYER_WIN,
    ENEMY_WIN
}

function team_is_player(_team) {
    return _team == Team.PLAYER || _team == "player";
}

function team_is_enemy(_team) {
    return _team == Team.ENEMY || _team == "enemy";
}

function team_is_active(_team) {
    return team_is_player(_team) || team_is_enemy(_team);
}
