local NOITA_FPS = 60

return {
    NOITA_FPS = NOITA_FPS;
    resetBestRTime = function()
            ModSettingRemove( "noFireTimer.bestr_time");
        end,
    saveBestTime = function()
        local frames = tonumber( GlobalsGetValue( "no_fire_frames", "0" ) ) or 0;
        local current_seconds = frames / NOITA_FPS;
        
        local bestr = tonumber( ModSettingGet( "noFireTimer.bestr_time" ) ) or 0;
        if current_seconds > bestr then
            ModSettingSet( "noFireTimer.bestr_time", current_seconds );
        end

        local bestg = tonumber( ModSettingGet( "noFireTimer.bestg_time" ) ) or 0;
        if current_seconds > bestg then
            ModSettingSet( "noFireTimer.bestg_time", current_seconds );
        end
end
}