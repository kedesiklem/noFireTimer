print("[noFireTimer] setting up GUI");
dofile_once( "data/scripts/lib/coroutines.lua" );
dofile_once( "data/scripts/lib/utilities.lua" );

local function safe_string_format( format, ... )
    local s = "";
    local status,result = pcall( function(...)
        s = string.format( format, ... );
    end, ... );
    if status == false then return "err"; end
    return s;
end

local gui = gui or GuiCreate();
local full_screen_width, full_screen_height = GuiGetScreenDimensions( gui );
GuiStartFrame( gui );
local screen_width, screen_height = GuiGetScreenDimensions( gui );

local gokiui = dofile_once( "mods/noFireTimer/files/mod_settings.lua" )( gui, 2, "noFireTimer", {
    { key="visibility",      label="Visibility",       default=1.0,  type="range",
      type_data={ min=0.01, max=1.0, text_callback=function(v) return math.floor(v*100).."%"; end } },
    { key="gui_x",           label="X",                default=24,   type="range",
      type_data={ min=0, max=screen_width,  value_callback=function(v) return math.floor(v+0.5); end } },
    { key="gui_y",           label="Y",                default=55,   type="range",
      type_data={ min=0, max=screen_height, value_callback=function(v) return math.floor(v+0.5); end } },
    { key="label_string",    label="Label",            default="Time not on fire: ",   type="input" },
    { key="show_bestr_time",  label="Show Best Run Time",   default=true,          type="boolean" },
    { key="bestr_label_string", label="Best Run Label",     default="Best [Run]: ",      type="input" },
    { key="show_bestg_time",  label="Show Best Global Time",   default=true,          type="boolean" },
    { key="bestg_label_string", label="Best Global Label",     default="Best [Global]: ",      type="input" },
    { key="show_death_by_fire_count",  label="Show Best Time",   default=true,          type="boolean" },
    { key="death_by_fire_count_string", label="Death Label",     default="Death by fire : ",      type="input" },
} );

local next_id  = gokiui.next_id;
local reset_id = gokiui.reset_id;

-- Convertit un float de secondes en "MM:SS.cc"
local function format_timer( seconds )
    if seconds == nil then seconds = 0; end
    local total_cs = math.floor( seconds * 100 );
    local cs = total_cs % 100;
    local s  = math.floor( total_cs / 100 ) % 60;
    local m  = math.floor( total_cs / 6000 );
    return string.format( "%02d:%02d.%02d", m, s, cs );
end

local function format_number( number )
    if number == nil then number = 0; end
    return string.format( "%d", number );
end

local is_panel_open = false;

function do_gui()
    reset_id();
    GuiStartFrame( gui );
    screen_width, screen_height = GuiGetScreenDimensions( gui );
    gokiui.parse_mod_settings();

    -- Panneau de config (hors inventaire)
    if not GameIsInventoryOpen() then
        GuiOptionsAdd( gui, GUI_OPTION.NoPositionTween );
        GuiLayoutBeginVertical( gui, 5, 15 );
            if is_panel_open then
                GuiBeginScrollContainer( gui, next_id(), 0, 0, 350, 110, false );
                    GuiLayoutBeginVertical( gui, 0, 0 );
                        GuiColorSetForNextWidget( gui, 0.5, 0.5, 0.5, 1.0 );
                        GuiOptionsAddForNextWidget( gui, GUI_OPTION.TextRichRendering );
                        GuiText( gui, 0, 0, "No-Fire Timer Options" );
                        GuiLayoutBeginHorizontal( gui, 0, 0 );
                            gokiui.do_gui();
                        GuiLayoutEnd( gui );
                    GuiLayoutEnd( gui );
                GuiEndScrollContainer( gui );
            end
        GuiLayoutEnd( gui );
        GuiOptionsRemove( gui, GUI_OPTION.NoPositionTween );
    end

    -- Lecture du Global exposé par la détection
    local raw = tonumber( GlobalsGetValue( "no_fire_seconds", "0" ) ) or 0;
    local text = safe_string_format( "%s%s",
        ModSettingGet( "noFireTimer.label_string" ),
        format_timer( raw )
    );

    local gx = ModSettingGet( "noFireTimer.gui_x" );
    local gy = ModSettingGet( "noFireTimer.gui_y" );

    GuiColorSetForNextWidget( gui, 1.0, 1.0, 1.0, ModSettingGet( "noFireTimer.visibility" ) );
    if GuiButton( gui, next_id(), gx, gy, text ) then
        is_panel_open = not is_panel_open;
    end
    if ModSettingGet( "noFireTimer.show_bestg_time" ) then
        local best = tonumber( ModSettingGet( "noFireTimer.bestg_time" ) ) or 0;
        local best_text = safe_string_format( "%s%s",
            ModSettingGet( "noFireTimer.bestg_label_string" ),
            format_timer( best )
        );
        GuiColorSetForNextWidget( gui, 0.8, 0.8, 0.8, ModSettingGet( "noFireTimer.visibility" ) );
        
        gy = gy + 8
        GuiText( gui, gx, gy, best_text );
    end
    if ModSettingGet( "noFireTimer.show_bestr_time" ) then
        local best = tonumber( ModSettingGet( "noFireTimer.bestr_time" ) ) or 0;
        local best_text = safe_string_format( "%s%s",
            ModSettingGet( "noFireTimer.bestr_label_string" ),
            format_timer( best )
        );
        GuiColorSetForNextWidget( gui, 0.8, 0.8, 0.8, ModSettingGet( "noFireTimer.visibility" ) );
        
        gy = gy + 8
        GuiText( gui, gx, gy, best_text );
    end
    

    if ModSettingGet( "noFireTimer.show_death_by_fire_count" ) then
        local best = tonumber( ModSettingGet( "noFireTimer.death_by_fire_count" ) ) or 0;
        local best_text = safe_string_format( "%s%s",
            ModSettingGet( "noFireTimer.death_by_fire_count_string" ),
            format_number( best )
        );
        GuiColorSetForNextWidget( gui, 0.8, 0.8, 0.8, ModSettingGet( "noFireTimer.visibility" ) );
        
        gy = gy + 8
        GuiText( gui, gx, gy, best_text );
    end
end

if gui then
    async_loop(function()
        if gui then
            local status, err = pcall( do_gui );
            if err then
                GamePrint("[noFireTimer] " .. err);
                print("[noFireTimer] " .. err);
            end
        end
        wait( 0 );
    end);
end