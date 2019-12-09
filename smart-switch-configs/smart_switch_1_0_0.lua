--[[
MIT License

Copyright (c) 2019 Peer Ligthart

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]--

--[[
#SMART_SWITCH.LUA
VERSION 1.0
COPYRIGHT © 2019 PEER LIGTHART <peer#5722>

#DESCRIPTION
SIMPLE SCRIPT WHICH ALLOWS YOU TO SWITCH CONFIGS ON CHANGING WEAPONS

release: smart_switch_1_0_0.lua
]]--

--#region CONSTANTS & VARIABLES
local DEBUG = false
local SPECTATOR_TEAM_ID = 1

local references = {}

local idx_to_name = {}
local name_to_idx = {}
local wep_id_to_idx = {}

local active_idx
local initialize_weapon
local current_wep_name

---#region INTERFACE
local enable_ref
local current_ref
local prefix_ref
local prefix_input_ref
local weapons_ref
local indicator_ref
local debug_ref

local load_ref = ui.reference("CONFIG", "Presets", "Load")
local delete_ref = ui.reference("CONFIG", "Presets", "Delete")
local reset_ref = ui.reference("CONFIG", "Presets", "Reset")
local import_ref = ui.reference("CONFIG", "Presets", "Import from clipboard")

---#endregion
---#region WEAPON DATA

local weapons, weapons_index = {}, {}
local weapons_data, weapons_data_types = {
    --[ID] = {"CONSOLE_NAME", "TYPE", "MAX_SPEED", "PRICE", "NAME", "CLIP_SIZE", "CYCLE_TIME"}
    [1]     = {"deagle", 1, 230, 700, "Desert Eagle", 7, 0.225},
    [2]     = {"elite", 1, 240, 400, "Dual Berettas", 30, 0.12},
    [3]     = {"fiveseven", 1, 240, 500, "Five-Seven", 20, 0.15},
    [4]     = {"glock", 1, 240, 200, "Glock-18", 20, 0.15},
    [7]     = {"ak47", 2, 215, 2700, "AK-47", 30, 0.1},
    [8]     = {"aug", 2, 220, 3300, "AUG", 30, 0.09},
    [9]     = {"awp", 2, 200, 4750, "AWP", 10, 1.455},
    [10]    = {"famas", 2, 220, 2250, "FAMAS", 25, 0.09},
    [11]    = {"g3sg1", 2, 215, 5000, "G3SG1", 20, 0.25},
    [13]    = {"galilar", 2, 215, 2000, "Galil AR", 35, 0.09},
    [14]    = {"m249", 3, 195, 5200, "M249", 100, 0.08},
    [16]    = {"m4a1", 2, 225, 3100, "M4A4", 30, 0.09},
    [17]    = {"mac10", 4, 240, 1050, "MAC-10", 30, 0.075},
    [19]    = {"p90", 4, 230, 2350, "P90", 50, 0.07},
    [23]    = {"mp5sd", 4, 235, 1500, "MP5-SD", 30, 0.08},
    [24]    = {"ump45", 4, 230, 1200, "UMP-45", 25, 0.09},
    [25]    = {"xm1014", 3, 215, 2000, "XM1014", 7, 0.35},
    [26]    = {"bizon", 4, 240, 1400, "PP-Bizon", 64, 0.08},
    [27]    = {"mag7", 3, 225, 1300, "MAG-7", 5, 0.85},
    [28]    = {"negev", 3, 150, 1700, "Negev", 150, 0.075},
    [29]    = {"sawedoff", 3, 210, 1100, "Sawed-Off", 7, 0.85},
    [30]    = {"tec9", 1, 240, 500, "Tec-9", 18, 0.12},
    [31]    = {"taser", 5, 220, 200, "Zeus x27", 1, 0.15},
    [32]    = {"hkp2000", 1, 240, 200, "P2000", 13, 0.17},
    [33]    = {"mp7", 4, 220, 1500, "MP7", 30, 0.08},
    [34]    = {"mp9", 4, 240, 1250, "MP9", 30, 0.07},
    [35]    = {"nova", 3, 220, 1050, "Nova", 8, 0.88},
    [36]    = {"p250", 1, 240, 300, "P250", 13, 0.15},
    [38]    = {"scar20", 2, 215, 5000, "SCAR-20", 20, 0.25},
    [39]    = {"sg556", 2, 210, 2750, "SG 553", 30, 0.09},
    [40]    = {"ssg08", 2, 230, 1700, "SSG 08", 10, 1.25},
    [42]    = {"knife", 6, 250, 0, "Knife", -1, 0.15},
    [43]    = {"flashbang", 7, 245, 200, "Flashbang", -1, 0.15},
    [44]    = {"hegrenade", 7, 245, 300, "High Explosive Grenade", -1, 0.15},
    [45]    = {"smokegrenade", 7, 245, 300, "Smoke Grenade", -1, 0.15},
    [46]    = {"molotov", 7, 245, 400, "Molotov", -1, 0.15},
    [47]    = {"decoy", 7, 245, 50, "Decoy Grenade", -1, 0.15},
    [48]    = {"incgrenade", 7, 245, 600, "Incendiary Grenade", -1, 0.15},
    [49]    = {"c4", 8, 250, 0, "C4 Explosive", -1, 0.15},
    [50]    = {"item_kevlar", 5, 1, 650, "Kevlar Vest", -1, 0.15},
    [51]    = {"item_assaultsuit", 5, 1, 1000, "Kevlar + Helmet", -1, 0.15},
    [52]    = {"item_heavyassaultsuit", 5, 1, 6000, "Heavy Assault Suit", -1, 0.15},
    [55]    = {"item_defuser", 5, 1, 400, "Defuse Kit", -1, 0.15},
    [56]    = {"item_cutters", 5, 1, 400, "Rescue Kit", -1, 0.15},
    [60]    = {"m4a1_silencer", 2, 225, 3100, "M4A1-S", 25, 0.1},
    [61]    = {"usp_silencer", 1, 240, 200, "USP-S", 12, 0.17},
    [63]    = {"cz75a", 1, 240, 500, "CZ75-Auto", 12, 0.1},
    [64]    = {"revolver", 1, 180, 600, "R8 Revolver", 8, 0.5}
}, {
    --WEAPON_TYPE
    "secondary", "rifle", "heavy", "smg", "equipment", "melee", "grenade", "c4"
}

local function populate_weapons_table()
    for idx, weapon in pairs(weapons_data) do
        local console_name, weapon_type = ("weapon_" .. weapon[1]):gsub(
            "weapon_item_", "item_"),
            weapons_data_types[weapon[2]]
        
        weapons[idx] = {
            console_name = console_name,
            idx = idx,
            type = weapon_type,
            max_speed = weapon[3],
            price = weapon[4],
            name = weapon[5],
            primary_clip_size = weapon[6],
            cycle_time = weapon[7]
        } 

        weapons_index[console_name] = weapons[idx]
    end
end

populate_weapons_table()

setmetatable(weapons, {
    __index = function(_, idx)
        if type(idx) == "string" then
            return weapons_index[idx]
        elseif type(idx) == "number" then
            idx = bit.band(idx, 0xFFFF)
            return rawget(weapons, idx)
        end
    end
})

---#endregion /WEAPON DATA
--#endregion /CONSTANT & VARIABLES

--#region UTILITY
---#region HELPERS
local function contains(tbl, val)
    for i=1,#tbl do
        if tbl[i] == val then
            return true
        end
    end
    return false
end

---#endregion /HELPERS

local function load_config(wep)
    local cfg_to_load = prefix_input_ref .. wep
    cfg_to_load = cfg_to_load:lower()

    current_wep_name = wep
end

local function preload(weapon_id)
    local wep_idx = wep_id_to_idx[weapon_id]

    if active_idx ~= wep_idx then
        active_idx = wep_idx

        local wep_name = idx_to_name[active_idx]
        local sel_weps = ui.get(weapons_ref)
        local wep_act = contains(sel_weps, wep_name)
        
        if wep_act then
            load_config(wep_name)
            ui.set(current_ref, "Current config: " .. ui.get(prefix_input_ref) ..  wep_name:lower())
        end
    end
end

local function update_config_tools_visibility(state)
    local display_state = state
    local script_state = ui.get(enable_ref)

    if display_state == nil then
        display_state = entity.is_alive(entity.get_local_player()) == false
    end

    ui.set(prefix_input_ref, "prefix_")

    ui.set_visible(load_ref, display_state)
    ui.set_visible(delete_ref, display_state)
    ui.set_visible(reset_ref, display_state)
    ui.set_visible(import_ref, display_state)

    return display_state
end

local function temp_task()
    update_config_tools_visibility()
    client.delay_call(5, temp_task)
end

--#endregion /UTILITY

--#region SCRIPT FUNCTIONALITY
---#region CALLBACKS
local function on_setup_command()
    if DEBUG then
        client.log("on_setup_command")
    end

    local local_player = entity.get_local_player()
    --Get local player's currently wielding weapon
    local weapon = entity.get_player_weapon(entity.get_local_player())
    --Get weapon id and toggle off 16th bit to get a useable id
    local weapon_id = bit.band(entity.get_prop(weapon, "m_iItemDefinitionIndex"), 0xFFFF)

    preload(weapon_id)
end

local function on_player_death(e)
    if DEBUG then
        client.log("on_player_death")
    end

    if client.userid_to_entindex(e.userid) == entity.get_local_player() then
        update_config_tools_visibility(true)
    end
end

local function on_player_spawn(e)
    if DEBUG then
        client.log("on_player_spawn")
    end

    if client.userid_to_entindex(e.userid) == entity.get_local_player() then
        update_config_tools_visibility(false)
    end
end

local function on_player_team_change(e)
    if DEBUG then
        client.log("on_player_team_change")
    end

    if client.userid_to_entindex(e.userid) == entity.get_local_player() then
        --Check if joined team is spectators
        if e.team == SPECTATOR_TEAM_ID then
            update_config_tools_visibility(true)
        end
    end
end

local function on_game_disconnect(e)
    if DEBUG then
        client.log("on_game_disconnect")
    end

    update_config_tools_visibility(true)
end

local function on_smart_switch_toggled(ref)
    local script_state = ui.get(ref)

    ui.set_visible(current_ref, script_state)
    ui.set_visible(prefix_ref, script_state)
    ui.set_visible(prefix_input_ref, script_state)
    ui.set_visible(weapons_ref, script_state)
    ui.set_visible(indicator_ref, script_state)

    if DEBUG then
        ui.set_visible(debug_ref, script_state)
    end

    update_config_tools_visibility()
    --Setunset event callbacks based on script state
    local setunset_callback = script_state and client.set_event_callback or client.unset_event_callback
    setunset_callback("setup_command", on_setup_command)
    setunset_callback("player_death", on_player_death)
    setunset_callback("player_spawn", on_player_spawn)
    setunset_callback("player_team", on_player_team_change)
    setunset_callback("cs_game_disconnected", on_game_disconnect)
end

client.set_event_callback("paint", function(c)
    if ui.get(indicator_ref) == true then
        if current_wep_name ~= nil then
            client.draw_indicator(c, 200, 194, 255, 255, "CFG: " .. current_wep_name:upper())
        end
    end
end)
---#endregion /CALLBACKS

---#region INITIALIZATION
local function initialize_weapon(wep, ...)
    local wep_idx = #references + 1
    references[wep_idx] = {}
    idx_to_name[wep_idx] = wep
    name_to_idx[wep] = wep_idx

    for _, wep_id in ipairs({...}) do
        wep_id_to_idx[wep_id] = wep_idx
    end

    return wep_idx
end

local function initialize()
    if DEBUG then
        client.log("Starting initialization...")
    end

    enable_ref = ui.new_checkbox(
        "LUA", "A", "Enable Smart Switch")

    current_ref = ui.new_label(
        "LUA", "A", "Current config: ")

    prefix_ref = ui.new_label(
        "LUA", "A", "Enter config prefix")
    
    prefix_input_ref = ui.new_textbox(
        "LUA", "A", "Enter config prefix")

    weapons_ref = ui.new_multiselect(
        "LUA", "A", "Active weapon configs",
        "Auto", "Scout", "Awp", "Revolver", "Desert-Eagle", "Pistols", "Rifles", "Sub-machine guns", "Knifes", "Grenades")
    
    indicator_ref = ui.new_checkbox(
        "LUA", "A", "Draw active weapon config indicator")

    if DEBUG then
        debug_ref = ui.new_checkbox(
            "LUA", "A", "Enable debugging")
    end

    initialize_weapon("Auto", 11, 38)
    initialize_weapon("Scout", 40)
    initialize_weapon("Awp", 9)
    initialize_weapon("Revolver", 64)
    initialize_weapon("Desert-Eagle", 1)
    initialize_weapon("Pistols", 2, 3, 4, 30, 32, 36, 61, 63)
    initialize_weapon("Rifles", 7, 8, 10, 13, 16, 39, 60)
    initialize_weapon("Sub-machine guns", 17, 19, 23, 24, 26, 33, 34)
    initialize_weapon("Knifes", 42, 500, 505, 506, 507, 508, 509, 515, 512, 516, 514, 519, 520, 522, 523, 503, 517, 518, 521, 525)
    initialize_weapon("Grenades", 44, 45, 46, 43, 47, 48)
    
    ui.set_callback(enable_ref, on_smart_switch_toggled)

    on_smart_switch_toggled(enable_ref)
end

initialize()

---#endregion /INITIALIZATION
--#endregion /SCRIPT FUNCTIONALITY