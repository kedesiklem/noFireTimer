dofile_once("data/scripts/lib/mod_settings.lua")

local mod_id  = "noFireTimer"
local gui_id  = 99001
local function id() gui_id = gui_id + 1; return gui_id; end

local empty = "data/debug/empty.png"

local function button(gui, x, text, color)
    GuiOptionsAddForNextWidget(gui, GUI_OPTION.Layout_NextSameLine)
    GuiText(gui, x, 0, "")
    local _, _, _, bx, by = GuiGetPreviousWidgetInfo(gui)
    text = "[" .. text .. "]"
    local w, h = GuiGetTextDimensions(gui, text)
    GuiOptionsAddForNextWidget(gui, GUI_OPTION.ClickCancelsDoubleClick)
    GuiOptionsAddForNextWidget(gui, GUI_OPTION.ForceFocusable)
    GuiOptionsAddForNextWidget(gui, GUI_OPTION.HandleDoubleClickAsClick)
    GuiImageNinePiece(gui, id(), bx, by, w, h, 0)
    local clicked, _, hovered = GuiGetPreviousWidgetInfo(gui)
    if color then GuiColorSetForNextWidget(gui, color[1], color[2], color[3], 1) end
    if hovered then GuiColorSetForNextWidget(gui, 1, 1, 0.7, 1) end
    GuiText(gui, x, 0, text)
    return clicked
end

local mod_settings = {
    {
        category_id = "records",
        ui_name     = "Records",
        foldable    = false,
        settings    = {
            {
                id          = "reset_best_time",
                not_setting = true,
                ui_fn       = function(_, gui, _, _, setting)
                    if button(gui, mod_setting_group_x_offset, "Reset best time", {1, 0.4, 0.4}) then
                        ModSettingRemove(mod_id .. ".best_time")
                    end
                end,
            },
        },
    },
}

function ModSettingsUpdate(init_scope)
end

function ModSettingsGuiCount()
    return mod_settings_gui_count(mod_id, mod_settings)
end

function ModSettingsGui(gui, in_main_menu)
    gui_id = 99001
    mod_settings_gui(mod_id, mod_settings, gui, in_main_menu)
end