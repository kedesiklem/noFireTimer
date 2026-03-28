local NOITA_FPS = 60;

local function is_player_on_fire( entity )
    return (GameGetGameEffect(entity, "ON_FIRE") ~= 0)
end

local entity = GetUpdatedEntityID();
local frames = tonumber( GlobalsGetValue( "no_fire_frames", "0" ) ) or 0;

if is_player_on_fire( entity ) then
    -- Le joueur vient de prendre feu : on sauvegarde le record si besoin, une seule fois
    if frames > 0 then
        local current_seconds = frames / NOITA_FPS;
        local best = tonumber( ModSettingGet( "noFireTimer.best_time" ) ) or 0;
        if current_seconds > best then
            ModSettingSet( "noFireTimer.best_time", current_seconds );
        end
    end
    frames = 0;
else
    frames = frames + 1;
end

local current_seconds = frames / NOITA_FPS;

GlobalsSetValue( "no_fire_frames",   tostring( frames ) );
GlobalsSetValue( "no_fire_seconds",  tostring( current_seconds ) );