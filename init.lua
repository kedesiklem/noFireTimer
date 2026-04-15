local time = dofile_once("mods/noFireTimer/files/scripts/timer.lua")

function OnPlayerSpawned( player_entity )

    if(not GameHasFlagRun("NOFIRETIMER_INIT")) then
        GameAddFlagRun("NOFIRETIMER_INIT")
        time.resetBestRTime()
    end

    EntityLoad( "mods/noFireTimer/files/gui/container.xml" );
    local luas_player = EntityGetComponentIncludingDisabled(player_entity, "LuaComponent")
    local need_skip = false
    if luas_player then
        for _, lua in pairs(luas_player) do
            if ComponentGetValue2(lua, "script_source_file") == "mods/noFireTimer/files/scripts/fire_detection.lua" then
                need_skip = true
            end
        end
    end
    if not need_skip then
        EntityAddComponent( player_entity, "LuaComponent", {
            script_source_file = "mods/noFireTimer/files/scripts/fire_detection.lua"
        });
    end

end

local function is_death_by_fire()
    local cause = StatsGetValue("killed_by")
    return (cause == " | fire")
end
local function increment_death_by_fire_count()
    local count = ModSettingGet( "noFireTimer.death_by_fire_count" );
    if count == nil then count = 0 end
    ModSettingSet( "noFireTimer.death_by_fire_count", count+1 );
end

function OnPlayerDied( player_entity )
    time.saveBestTime()
    if is_death_by_fire() then
        increment_death_by_fire_count()
    end
end

-- function OnPausedChanged(is_paused, is_inventory_pause)
--     time.saveBestTime()
-- end