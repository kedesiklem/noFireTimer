dofile_once( "mods/noFireTimer/files/lib/helper.lua");
dofile_once( "mods/noFireTimer/files/lib/variables.lua");

function OnPlayerSpawned( player_entity )
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