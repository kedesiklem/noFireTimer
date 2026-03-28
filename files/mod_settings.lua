return function( gui, gui_id, mod_settings_id, mod_settings )
    local id_offset = 0;

    local function word_wrap( str, wrap_size )
        if str then
            if wrap_size == nil then wrap_size = 60; end
            local last_space_index = 1;
            local last_wrap_index = 0;
            for i=1,#str do
                if str:sub(i,i) == " " then
                    last_space_index = i;
                end
                if str:sub(i,i) == "\n" then
                    last_space_index = i;
                    last_wrap_index = i;
                end
                if i - last_wrap_index > wrap_size then
                    str = str:sub(1,last_space_index-1) .. "\n" .. str:sub(last_space_index + 1);
                    last_wrap_index = i;
                end
            end
            return str;
        end
        return "";
    end

    local function reset_id()
        id_offset = 1;
    end

    local function next_id()
        id_offset = id_offset + 1;
        return gui_id + id_offset;
    end

    local has_been_parsed = false;
    local function parse_mod_settings()
        if not has_been_parsed then
            has_been_parsed = true;
            for _,setting in ipairs( mod_settings ) do
                if ModSettingGet( mod_settings_id.."."..setting.key ) == nil then
                    ModSettingSet( mod_settings_id.."."..setting.key, setting.default );
                end
                setting.current = ModSettingGet( mod_settings_id.."."..setting.key );
            end
        end
    end

    local gui_functions = {
        boolean = function( setting )
            if GuiImageButton( gui, next_id(), 0, 0, "", "mods/noFireTimer/files/gui/checkbox" .. (setting.current == true and "_fill" or "") .. ".png" ) then
                setting.current = not setting.current;
                ModSettingSet( mod_settings_id.."."..setting.key, setting.current );
                GuiLayoutAddVerticalSpacing( gui, 1 );
            end
        end,
        range = function( setting )
            local new_value = GuiSlider( gui, next_id(), -2, 0, "", setting.current, setting.type_data.min, setting.type_data.max, setting.default, 1.0, " ", 100 );
            if setting.type_data.value_callback ~= nil then
                new_value = setting.type_data.value_callback( new_value );
            end
            if setting.current ~= new_value then
                setting.current = new_value;
                ModSettingSet( mod_settings_id.."."..setting.key, setting.current );
            end
        end,
        input = function( setting )
            local new_value = GuiTextInput( gui, next_id(), 0, 0, setting.current, 200, 100 );
            if setting.current ~= new_value then
                setting.current = new_value;
                ModSettingSet( mod_settings_id.."."..setting.key, setting.current );
            end
        end,
    }

    local function do_gui()
        GuiLayoutBeginVertical( gui, 0, 0 );
            for _,setting in ipairs( mod_settings ) do
                GuiText( gui, 0, 0, setting.label );
                if setting.tooltip then GuiTooltip( gui, setting.tooltip, ""); end
            end
        GuiLayoutEnd( gui );

        GuiLayoutAddHorizontalSpacing( gui, 1 );
        GuiLayoutAddHorizontalSpacing( gui, 1 );
        GuiLayoutAddHorizontalSpacing( gui, 1 );
        GuiLayoutAddHorizontalSpacing( gui, 1 );

        GuiLayoutBeginVertical( gui, 0, 0 );
            for _,setting in ipairs( mod_settings ) do
                GuiLayoutBeginHorizontal( gui, 0, 0 );
                    if gui_functions[setting.type] then
                        gui_functions[setting.type]( setting );
                        if setting.validation_callback then
                            local result = setting.validation_callback( setting.current );
                            if result ~= true then
                                GuiTooltip( gui, word_wrap( result ), "" );
                            end
                        end
                    end
                    if setting.type == "range" then
                        if setting.type_data.text_callback then
                            GuiText( gui, 0, 0, setting.type_data.text_callback( setting.current ) );
                        else
                            GuiText( gui, 0, 0, tostring( setting.current ) );
                        end
                    elseif setting.type == "input" then
                        if GuiButton( gui, next_id(), 0, 0, "[Reset]" ) then
                            ModSettingSet( mod_settings_id.."."..setting.key, setting.default );
                            setting.current = setting.default;
                        end
                    end
                GuiLayoutEnd( gui );
                if setting.type == "range" then
                    GuiLayoutAddVerticalSpacing( gui, -2 );
                elseif setting.type == "input" then
                    GuiLayoutAddVerticalSpacing( gui, -2 );
                end
            end
        GuiLayoutEnd( gui );
    end

    return {
        reset_id = reset_id,
        next_id = next_id,
        parse_mod_settings = parse_mod_settings,
        do_gui = do_gui
    }
end
