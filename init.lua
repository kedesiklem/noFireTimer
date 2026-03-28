dofile_once( "mods/noFireTimer/files/lib/helper.lua");
dofile_once( "mods/noFireTimer/files/lib/variables.lua");

function OnPlayerSpawned( player_entity )
    EntityLoad( "mods/noFireTimer/files/gui/container.xml" );
    EntityAddComponent( player_entity, "LuaComponent", {
        script_source_file = "mods/noFireTimer/files/scripts/fire_detection.lua"
    });
end