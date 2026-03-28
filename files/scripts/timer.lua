local NOITA_FPS = 60

return {
    NOITA_FPS = NOITA_FPS;
    saveBestTime = function()
        local frames = tonumber( GlobalsGetValue( "no_fire_frames", "0" ) ) or 0;
        local current_seconds = frames / NOITA_FPS;
        local best = tonumber( ModSettingGet( "noFireTimer.best_time" ) ) or 0;
        if current_seconds > best then
            ModSettingSet( "noFireTimer.best_time", current_seconds );
        end
end
}