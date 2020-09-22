--#region gamesense api

local UI_Reference, UI_New_Checkbox, UI_New_Slider, UI_New_Hotkey, UI_Set_Visible, UI_Get, UI_Set, UI_Set_Callback = ui.reference, ui.new_checkbox, ui.new_slider, ui.new_hotkey, ui.set_visible, ui.get, ui.set, ui.set_callback
local String_Format, Renderer_Indicator, Set_Event_Callback, Unset_Event_Callback = string.format, renderer.indicator, client.set_event_callback, client.unset_event_callback
--#endregion

--#region globals & helpers

local Active_Prev, Value_Prev = false, nil

local Slider_Tooltips = {
    [0] = "Auto"
}

local function Multi_Exec(func, tab)
    if func == nil then return end

    for k, v in pairs(tab) do
        func(k, v)
    end
end
--#endregion

--#region menu & references

local Ref_Minimum_Damage = UI_Reference("rage", "Aimbot", "Minimum damage")

local M = { "rage", "Other" }
local Interface = {
    Master_Switch = UI_New_Checkbox(M[1], M[2], "Enable damage override"),
    Hotkey = UI_New_Hotkey(M[1], M[2], "Damage override hotkey", true),
    Default_Value = UI_New_Slider(M[1], M[2], "Default minimum damage", 0, 126, 0, true, nil, 1, Slider_Tooltips),
    High_Value = UI_New_Slider(M[1], M[2], "\n", 0, 126, 101, true, nil, 1, Slider_Tooltips),
    Hotkey_High = UI_New_Hotkey(M[1], M[2], "Damage override high hotkey", true),
    Low_Value = UI_New_Slider(M[1], M[2], "\n", 0, 126, 5, true, nil, 1, Slider_Tooltips),
    Hotkey_Low = UI_New_Hotkey(M[1], M[2], "Damage override low hotkey", true)
}
--#endregion

--#region main

local function Main()
    local Active = UI_Get(Interface.Master_Switch) and UI_Get(Interface.Hotkey)

    UI_Set(Interface.Hotkey, "Toggle")
    UI_Set(Interface.Hotkey_High, "Toggle")
    UI_Set(Interface.Hotkey_Low, "On hotkey")

    if Active then
        if not Active_Prev then
            Value_Prev = UI_Get(Ref_Minimum_Damage)
        end

        local Val = UI_Get(Ref_Minimum_Damage)

        if UI_Get(Interface.Hotkey_High) then
            Val = UI_Get(Interface.High_Value)
        elseif UI_Get(Interface.Hotkey_Low) then
            Val = UI_Get(Interface.Low_Value)
        end

        UI_Set(Interface.Default_Value, Val)
        Renderer_Indicator(255, 255, 255, 255, Slider_Tooltips[Val] or Val)
        UI_Set(Ref_Minimum_Damage, Val)
    elseif Active_Prev then
        if Value_Prev ~= nil then
            UI_Set(Ref_Minimum_Damage, Value_Prev)
            Value_Prev = nil
        end
    end

    Active_Prev = Active
end
--#endregion

--#region initialize
local function Handle_Interface()
    local Enabled = UI_Get(Interface.Master_Switch)

    Multi_Exec(UI_Set_Visible, {
        [Interface.High_Value] = Enabled,
        [Interface.Hotkey_High] = Enabled,
        [Interface.Low_Value] = Enabled,
        [Interface.Hotkey_Low] = Enabled,
        [Interface.Default_Value] = false
    })
end

local function Setup()
    for i=1, 26 do
        Slider_Tooltips[100 + i] = String_Format("HP+%s", i)
    end
end

local function Script_Toggled()
    local Enabled = UI_Get(Interface.Master_Switch)

    Handle_Interface()

    if Enabled then
        Setup()
    end

    local Callback = Enabled and Set_Event_Callback or Unset_Event_Callback
    Callback("paint", Main)
end

Script_Toggled()
UI_Set_Callback(Interface.Master_Switch,Script_Toggled)
--#endregion