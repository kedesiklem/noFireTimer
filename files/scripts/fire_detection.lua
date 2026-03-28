local NOITA_FPS = 60;

local function is_player_on_fire( entity )
    return (GameGetGameEffect(entity, "ON_FIRE") ~= 0)
end

local entity = GetUpdatedEntityID();
local frames = tonumber( GlobalsGetValue( "no_fire_frames", "0" ) ) or 0;

if is_player_on_fire( entity ) then
    frames = 0;
else
    frames = frames + 1;
end

GlobalsSetValue( "no_fire_frames",   tostring( frames ) );
GlobalsSetValue( "no_fire_seconds",  tostring( frames / NOITA_FPS ) );