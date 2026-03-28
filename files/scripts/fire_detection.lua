local time = dofile_once("mods/noFireTimer/files/scripts/timer.lua")

local function is_player_on_fire( entity )
    return (GameGetGameEffect(entity, "ON_FIRE") ~= 0)
end

local entity = GetUpdatedEntityID();
local frames = tonumber( GlobalsGetValue( "no_fire_frames", "0" ) ) or 0;

if is_player_on_fire( entity ) then
    -- Le joueur vient de prendre feu : on sauvegarde le record si besoin, une seule fois
    if frames > 0 then
        time.saveBestTime()
    end
    frames = 0;
else
    frames = frames + 1;
end

local current_seconds = frames / time.NOITA_FPS;

GlobalsSetValue( "no_fire_frames",   tostring( frames ) );
GlobalsSetValue( "no_fire_seconds",  tostring( current_seconds ) );