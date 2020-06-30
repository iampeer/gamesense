--#region API
local ui = {
    checkbox = ui.new_checkbox,
    slider = ui.new_slider,
    multiselect = ui.new_multiselect,
    combobox = ui.new_combobox,
    label = ui.new_label,
    textbox = ui.new_textbox,
    color_picker = ui.new_color_picker,
    hotkey = ui.new_hotkey,

    set = ui.set,
    get = ui.get,
    ref = ui.reference,
    callback = ui.set_callback,
    visible = ui.set_visible
}

--#endregion

--SCRIPT
local script = {
    _debug = false,

    menu = { "config", "Presets" },

    groups = {
        awp = { 9 },
        auto = { 11, 38 },
        scout = { 40 },
        revolver = { 64 },
        deagle = { 1 },
        pistol = { 2, 3, 4, 30, 32, 36, 61, 63 },
        rifle = { 7, 8, 10, 13, 16, 39, 60 },
        smg = { 17, 19, 24, 26, 33, 34 },
        heavy = { 14, 28 },
        shotgun = { 25, 27, 29, 35 }
    }
}

function script:call(func, name, ...)
    if func == nil then
        return
    end

    local end_name = name[2] or ""

    if name[1] ~= nil then
        end_name = end_name ~= "" and (end_name .. " ") or end_name
        end_name = end_name .. "\n " .. name[1]
    end

    return func(self.menu[1], self.menu[2], end_name, ...)
end

--VARS
local active_key
local config_name
local load_name
local cached_name

--#region HELPERS
local contains = function(tbl, val)
    for i=1, #tbl do
        if (tbl[i] == val) then
            return true
        end
    end

    return false
end

local multi_exec = function(func, list)
    if (func == nil) then
        return false
    end
    
    for ref, val in pairs(list) do
        func(ref, val)
    end
end

local upper_first_char = function(str)
    return (str:gsub("^%l", string.upper))
end

local get_table_keys = function(tbl)
    local items = { }
    local n = 1

    for k, v in pairs(tbl) do
        items[n] = upper_first_char(k)
        n = n + 1
    end

    table.sort(items)
    return items
end

local get_active_key = function(idx)
    for k, v in pairs(script.groups) do
        if contains(v, idx) then
            return upper_first_char(k)
        end
    end

    return false
end

local get_weapon_index = function(ent)
    local ent_weapon = entity.get_player_weapon(ent)
    return (bit.band(65535, entity.get_prop(ent_weapon, "m_iItemDefinitionIndex")))
end

local is_non_weapon = function(idx)
    if (idx > 40 and idx < 50 or idx > 499 and idx < 524 or idx == 31) then
        return true
    end
end
--#endregion

--CONTROLS
local hor_line = ui.label(script.menu[1], script.menu[2], "-------------------------------------------------")
local disabled = script:call(ui.checkbox, { "rcl_disabled", "Disable weapon based preset loading" })
local active_lbl = script:call(ui.label, { "rcl_active_lbl", "Active preset:" })
local prefix_lbl = script:call(ui.label, { "rcl_prefix_lbl", "Preset name prefix" })
local prefix = script:call(ui.textbox, { "rcl_prefix", "preset_name_prefix" })
local selected = script:call(ui.multiselect, { "rcl_selected", "Selected weapon groups" }, get_table_keys(script.groups))
local indicator = script:call(ui.checkbox, { "rcl_indicator", "Indicate current preset name" })
local color = script:call(ui.color_picker, { "rcl_indicator_color", "indicator_color" }, 123, 193, 21, 255)

--#region FUNCTIONS
local config_load = function(name)
    local final_name = string.format("%s%s", ui.get(prefix), name)
    local _disabled, _prefix, _selected, _indicator = ui.get(disabled), ui.get(prefix), ui.get(selected), ui.get(indicator)

    config.load(final_name)
    
    config_name = final_name
    ui.set(active_lbl, string.format("Active preset: %s", final_name))

    multi_exec(ui.set, {
        [disabled] = _disabled,
        [prefix] = _prefix,
        [selected] = _selected,
        [indicator] = _indicator
    })
end

local prepare_config_load = function(idx)
    if is_non_weapon(idx) then
        return
    end

    local wpn_string = get_active_key(idx)
    local selected_groups = ui.get(selected)

    if not contains(selected_groups, upper_first_char(wpn_string)) then
        wpn_string = "global"
    end
    
    if contains(selected_groups, upper_first_char(wpn_string)) and wpn_string ~= "global" then
        load_name = string.lower(wpn_string)
    else
        load_name = "global"
    end

    config_load(load_name)
end
--#endregion

--#region EVENTS
local on_net_end_update = function(c)
    local me = entity.get_local_player()
    if (not entity.is_alive(me)) then
        return
    end
    
    if (get_weapon_index(me) == active_key) then
        return
    end

    active_key = get_weapon_index(me)
    prepare_config_load(active_key)
end

local on_paint = function()
    if not ui.get(indicator) then
        return
    end
    
    if not config_name then
        return
    end

    local r, g, b, a = ui.get(color)

    renderer.indicator(r, g, b, a, string.upper(config_name))
end
--#endregion

--VISIBILITY
local update_visibility = function()
    local script_state = not ui.get(disabled)

    multi_exec(ui.visible, {
        [active_lbl] = script_state,
        [prefix_lbl] = script_state,
        [prefix] = script_state,
        [selected] = script_state,
        [indicator] = script_state,
        [color] = script_state
    })
end

--INITIALIZATION
local script_toggled = function()
    local state = not ui.get(disabled)

    update_visibility()

    local update_callback = state and client.set_event_callback or client.unset_event_callback
    update_callback("net_update_end", on_net_end_update)
    update_callback("paint", on_paint)
end

script_toggled()
ui.callback(disabled, script_toggled)
ui.callback(indicator, update_visibility)