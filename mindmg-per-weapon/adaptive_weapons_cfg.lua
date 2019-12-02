-- ######
-- LOCAL VARIABLES FOR LUA API
-- Generated using https://github.com/sapphyrus/gamesense-lua/blob/master/generate_api.lua
-- #####
local client_userid_to_entindex, client_set_event_callback, client_screen_size, client_trace_bullet, client_unix_time, client_color_log, client_reload_active_scripts, client_scale_damage, client_get_cvar, client_key_state, client_create_interface, client_random_int, client_latency, client_set_clan_tag, client_find_signature, client_log, client_timestamp, client_trace_line, client_random_float, client_draw_debug_text, client_visible, client_exec, client_error_log, client_set_cvar, client_camera_position, client_draw_hitboxes, client_eye_position, client_update_player_list, client_camera_angles, client_delay_call, client_unset_event_callback, client_system_time = client.userid_to_entindex, client.set_event_callback, client.screen_size, client.trace_bullet, client.unix_time, client.color_log, client.reload_active_scripts, client.scale_damage, client.get_cvar, client.key_state, client.create_interface, client.random_int, client.latency, client.set_clan_tag, client.find_signature, client.log, client.timestamp, client.trace_line, client.random_float, client.draw_debug_text, client.visible, client.exec, client.error_log, client.set_cvar, client.camera_position, client.draw_hitboxes, client.eye_position, client.update_player_list, client.camera_angles, client.delay_call, client.unset_event_callback, client.system_time
local entity_get_player_resource, entity_get_local_player, entity_is_enemy, entity_get_bounding_box, entity_is_dormant, entity_get_steam64, entity_get_player_name, entity_hitbox_position, entity_get_game_rules, entity_get_all, entity_set_prop, entity_is_alive, entity_get_player_weapon, entity_get_prop, entity_get_players, entity_get_classname = entity.get_player_resource, entity.get_local_player, entity.is_enemy, entity.get_bounding_box, entity.is_dormant, entity.get_steam64, entity.get_player_name, entity.hitbox_position, entity.get_game_rules, entity.get_all, entity.set_prop, entity.is_alive, entity.get_player_weapon, entity.get_prop, entity.get_players, entity.get_classname
local globals_realtime, globals_absoluteframetime, globals_chokedcommands, globals_oldcommandack, globals_tickcount, globals_commandack, globals_lastoutgoingcommand, globals_curtime, globals_mapname, globals_tickinterval, globals_framecount, globals_frametime, globals_maxplayers = globals.realtime, globals.absoluteframetime, globals.chokedcommands, globals.oldcommandack, globals.tickcount, globals.commandack, globals.lastoutgoingcommand, globals.curtime, globals.mapname, globals.tickinterval, globals.framecount, globals.frametime, globals.maxplayers
local ui_new_slider, ui_new_combobox, ui_reference, ui_set_visible, ui_new_textbox, ui_new_color_picker, ui_new_checkbox, ui_mouse_position, ui_new_listbox, ui_new_multiselect, ui_is_menu_open, ui_new_hotkey, ui_set, ui_name, ui_set_callback, ui_new_button, ui_new_label, ui_new_string, ui_get = ui.new_slider, ui.new_combobox, ui.reference, ui.set_visible, ui.new_textbox, ui.new_color_picker, ui.new_checkbox, ui.mouse_position, ui.new_listbox, ui.new_multiselect, ui.is_menu_open, ui.new_hotkey, ui.set, ui.name, ui.set_callback, ui.new_button, ui.new_label, ui.new_string, ui.get
local renderer_get_text_size, renderer_load_svg, renderer_draw_localized_text, renderer_circle_outline, renderer_rectangle, renderer_world_to_screen, renderer_lock_cursor, renderer_unlock_cursor, renderer_line, renderer_get_mouse_pos, renderer_set_mouse_pos, renderer_localize_string, renderer_draw_outlined_rect, renderer_draw_text, renderer_draw_poly_line, renderer_texture, renderer_load_png, renderer_draw_filled_gradient_rect, renderer_indicator, renderer_create_font, renderer_test_font, renderer_gradient, renderer_circle, renderer_text, renderer_draw_line, renderer_draw_filled_rect, renderer_draw_filled_outlined_rect, renderer_triangle, renderer_measure_text, renderer_load_texture, renderer_draw_outlined_circle, renderer_load_jpg = renderer.get_text_size, renderer.load_svg, renderer.draw_localized_text, renderer.circle_outline, renderer.rectangle, renderer.world_to_screen, renderer.lock_cursor, renderer.unlock_cursor, renderer.line, renderer.get_mouse_pos, renderer.set_mouse_pos, renderer.localize_string, renderer.draw_outlined_rect, renderer.draw_text, renderer.draw_poly_line, renderer.texture, renderer.load_png, renderer.draw_filled_gradient_rect, renderer.indicator, renderer.create_font, renderer.test_font, renderer.gradient, renderer.circle, renderer.text, renderer.draw_line, renderer.draw_filled_rect, renderer.draw_filled_outlined_rect, renderer.triangle, renderer.measure_text, renderer.load_texture, renderer.draw_outlined_circle, renderer.load_jpg
local math_ceil, math_tan, math_cos, math_sinh, math_pi, math_max, math_atan2, math_floor, math_sqrt, math_deg, math_atan, math_fmod, math_acos, math_pow, math_abs, math_min, math_sin, math_log, math_exp, math_cosh, math_asin, math_rad = math.ceil, math.tan, math.cos, math.sinh, math.pi, math.max, math.atan2, math.floor, math.sqrt, math.deg, math.atan, math.fmod, math.acos, math.pow, math.abs, math.min, math.sin, math.log, math.exp, math.cosh, math.asin, math.rad
local table_sort, table_remove, table_concat, table_insert = table.sort, table.remove, table.concat, table.insert
local string_find, string_format, string_gsub, string_len, string_gmatch, string_match, string_reverse, string_upper, string_lower, string_sub = string.find, string.format, string.gsub, string.len, string.gmatch, string.match, string.reverse, string.upper, string.lower, string.sub
local materialsystem_chams_material, materialsystem_arms_material, materialsystem_find_texture, materialsystem_find_material, materialsystem_override_material, materialsystem_find_materials, materialsystem_get_model_materials = materialsystem.chams_material, materialsystem.arms_material, materialsystem.find_texture, materialsystem.find_material, materialsystem.override_material, materialsystem.find_materials, materialsystem.get_model_materials
local ipairs, assert, pairs, next, tostring, tonumber, setmetatable, unpack, type, getmetatable, pcall, error = ipairs, assert, pairs, next, tostring, tonumber, setmetatable, unpack, type, getmetatable, pcall, error
-- #####
-- END OF LOCAL VARIABLES
-- #####

--------------------------------------------------------------------------------
-- Constants and variables
--------------------------------------------------------------------------------
local enable_ref
local config_ref
local label_ref
-- local config_ref_visible = true

-- Array of aimbot references
-- references[IDX_BUILTIN] is an array of references to the built-in menu items
-- references[IDX_GLOBAL] is an array of references to the global config
local references  = {}
local IDX_BUILTIN = 1
local IDX_GLOBAL  = 2

local config_idx_to_name = {}
local config_name_to_idx = {}
local weapon_id_to_config_idx = {}

-- Active weapon config is managed by the script when the local player is alive
-- Active weapon config is managed by the user (via the menu) while the local player is dead
local active_config_idx = nil

local SPECATOR_TEAM_ID = 1

--------------------------------------------------------------------------------
-- Utility functions
--------------------------------------------------------------------------------
local function copy_settings(config_idx_src, config_idx_dst)
    local src_refs = references[config_idx_src]
    local dst_refs = references[config_idx_dst]
    for i=1, #dst_refs do
        ui.set(dst_refs[i], ui.get(src_refs[i]))
    end
end

local function load_config(config_idx)
    if active_config_idx ~= config_idx then
        active_config_idx = config_idx
        copy_settings(config_idx, IDX_BUILTIN)
        ui.set(label_ref, "Active weapon config: " .. config_idx_to_name[config_idx])
    end
end

local function update_config_visibility(state)
    local display_config = state
    local script_state = ui.get(enable_ref)
    if display_config == nil then
        display_config = entity.is_alive(entity.get_local_player()) == false
    end
    local display_label = not display_config
    -- config_ref_visible = display_config
    ui.set_visible(config_ref, display_config and script_state)
    ui.set_visible(label_ref, display_label and script_state)
    return display_config
end

local function save_reference(config_idx, setting_idx, ref)
    references[config_idx][setting_idx] = ref
    return ref
end

local function bind(func, ...)
    local args = {...}
    return function(ref)
        func(ref, unpack(args))
    end
end

local function delayed_bind(func, delay, ...)
    local args = {...}
    return function(ref)
        client.delay_call(delay, func, ref, unpack(args))
    end
end

-- Temporary function for enabling config in the menu
local function temp_task()
    update_config_visibility()
    client.delay_call(5, temp_task)
end
--------------------------------------------------------------------------------
-- Callback functions
--------------------------------------------------------------------------------
local function on_setup_command()
    local local_player = entity.get_local_player()
    -- Get the local players weapon so we can find its item definition index
    local weapon = entity.get_player_weapon(local_player)
    -- Get the weapons item definition and toggle off the 16th bit to get the real item def index
    local weapon_id = bit.band(entity.get_prop(weapon, "m_iItemDefinitionIndex"), 0xFFFF)
    -- Use the weapon_id_to_config_idx lookup table to get the new config index and attempt to load the config
    load_config(weapon_id_to_config_idx[weapon_id] or IDX_GLOBAL)
end

local function on_player_death(e)
    if client.userid_to_entindex(e.userid) == entity.get_local_player() then
        update_config_visibility(true)
    end
end

local function on_player_spawn(e)
    if client.userid_to_entindex(e.userid) == entity.get_local_player() then
        update_config_visibility(false)
    end
end

local function on_player_team_change(e)
    if client.userid_to_entindex(e.userid) == entity.get_local_player() then
        -- Check if the team the local player switched to is spectator(1)
        if e.team == SPECATOR_TEAM_ID then
            update_config_visibility(true)
        end
    end
end

local function on_game_disconnect(e)
    update_config_visibility(true)
end

-- Called when a user selects a different weapon config with the combobox
local function on_weapon_config_selected(ref)
    -- If the local player is alive then do nothing and hide this combobox
    if update_config_visibility() == false then
        -- This should never happen
        -- client.error_log("Weapon config selected while local player is alive!")
        return
    end

    -- Load settings from the selected weapon config
    local config_name = ui.get(ref)
    local config_idx = config_name_to_idx[config_name]
    load_config(config_idx)
end

-- Called when a user changes the value of a built-in menu item (e.g. checking "Automatic penetrationn")
-- Also called when a config is loaded
local function on_builtin_setting_change(ref, setting_idx)
    -- Propagate built-in setting changes to the adaptive settings
    if active_config_idx ~= nil and ui.get(enable_ref) == true then
        ui.set(references[active_config_idx][setting_idx], ui.get(ref))
    end
end

-- Called when a user changes the value of a weapon configs menu item (e.g. checking "Global automatic penetration")
-- Also called when a config is loaded
local function on_adaptive_setting_changed(ref, config_idx, setting_idx)
    -- Propagate adaptive setting changes to the built-in settings
    if config_idx == active_config_idx and ui.get(enable_ref) == true then
        ui.set(references[IDX_BUILTIN][setting_idx], ui.get(ref))
    end
end

-- Called when a user toggles the main script checkbox
-- Also called on script load
local function on_adaptive_config_toggled(ref)
    local script_state = ui.get(ref)
    -- Update the configs visibility when the script is toggled
    update_config_visibility()
    -- Set / unset event callbacks based on the state of the script so that we aren't just invoking callbacks for no reason
	local update_callback = script_state and client.set_event_callback or client.unset_event_callback
    update_callback("setup_command", on_setup_command)
    update_callback("player_death", on_player_death)
    update_callback("player_spawn", on_player_spawn)
    update_callback("player_team", on_player_team_change)
    update_callback("cs_game_disconnected", on_game_disconnect)
end

--------------------------------------------------------------------------------
-- Initialization code
--------------------------------------------------------------------------------
local function duplicate(tab, container, name, ui_func, ...)
    -- This menu item will have the same index across all weapon configs
    local setting_index = #references[IDX_BUILTIN] + 1
    -- Create hidden menu items to store values
    for i=IDX_GLOBAL, #references do
        local config_name = config_idx_to_name[i]
        -- Create a duplicate menu item to store settings that can be copied later
        local ref = save_reference(i, setting_index, ui_func(tab, container, config_name .. " " .. name:lower(), ...))
        -- Set a default value for the target hitbox as this multiselect cannot be empty
        if name == "Target hitbox" then
            ui.set(ref, {"Head"})
        end
        ui.set_visible(ref, false)
        ui.set_callback(ref, bind(on_adaptive_setting_changed, i, setting_index))
    end
    local ref = save_reference(IDX_BUILTIN, setting_index, ui.reference(tab, container, name))
    -- Set a callback on the built-in menu items so that settings are not overwritten whenever we are loading a new config
    ui.set_callback(ref, delayed_bind(on_builtin_setting_change, 0.01, setting_index))
end

local function init_config(name, ...)
    local config_idx = #references + 1
    references[config_idx] = {}
    config_idx_to_name[config_idx] = name
    config_name_to_idx[name] = config_idx
    -- Populate the weapon_id_to_config_idx lookup table so we can easily get a configs index from a weapon id
    for _, weapon_id in ipairs({...}) do
        weapon_id_to_config_idx[weapon_id] = config_idx
    end
    return config_idx
end

local function init()
    IDX_BUILTIN = init_config("Built-in menu items")
	init_config("Global")
	init_config("Auto", 11, 38)
	init_config("Awp", 9)
	init_config("Scout", 40)
	init_config("Desert Eagle", 1)
	init_config("Revolver", 64)
	init_config("Pistol", 2, 3, 4, 30, 32, 36, 61, 63)
	init_config("Rifle", 7, 8, 10, 13, 16, 39, 60)
	-- init_config("Submachine gun", 17, 19, 23, 24, 26, 33, 34)
	-- init_config("Machine gun", 14, 28)
    -- init_config("Shotgun", 25, 27, 29, 35)
    
    assert(config_idx_to_name[IDX_GLOBAL] == "Global")

    enable_ref = ui.new_checkbox("RAGE", "Other", "Adaptive config")
    config_ref = ui.new_combobox("RAGE", "Other", "\nAdaptive config", config_idx_to_name)
    label_ref = ui.new_label("RAGE", "Other", "Active weapon config: " .. ui.get(config_ref))
    
    duplicate("RAGE", "Aimbot", "Target selection", ui.new_combobox, "Cycle", "Cycle (2x)", "Near crosshair", "Highest damage", "Lowest ping", "Best K/D ratio", "Best hit chance")
	duplicate("RAGE", "Aimbot", "Target hitbox", ui.new_multiselect, "Head", "Chest", "Stomach", "Arms", "Legs", "Feet")
	duplicate("RAGE", "Aimbot", "Avoid limbs if moving", ui.new_checkbox)
	duplicate("RAGE", "Aimbot", "Avoid head if jumping", ui.new_checkbox)
	duplicate("RAGE", "Aimbot", "Multi-point", ui.new_multiselect, "Head", "Chest", "Stomach", "Arms", "Legs", "Feet")
	duplicate("RAGE", "Aimbot", "Multi-point scale", ui.new_slider, 24, 100, 24, true, "%", 1, multipoint_override)
	duplicate("RAGE", "Aimbot", "Dynamic multi-point", ui.new_checkbox)
	duplicate("RAGE", "Aimbot", "Prefer safe point", ui.new_checkbox)
	duplicate("RAGE", "Aimbot", "Automatic fire", ui.new_checkbox)
	duplicate("RAGE", "Aimbot", "Automatic penetration", ui.new_checkbox)
	duplicate("RAGE", "Aimbot", "Silent aim", ui.new_checkbox)
	duplicate("RAGE", "Aimbot", "Minimum hit chance", ui.new_slider, 0, 100, 50, true, "%", 1, hitchance_override)
	duplicate("RAGE", "Aimbot", "Minimum damage", ui.new_slider, 0, 126, 0, true, "%", 1, mindamage_override)
	duplicate("RAGE", "Aimbot", "Automatic scope", ui.new_checkbox)
    duplicate("RAGE", "Aimbot", "Maximum FOV", ui.new_slider, 1, 180, 180, true, "°")
    duplicate("RAGE", "Aimbot", "Override minimum damage", ui.new_slider, 0, 126, 0, true, "", 1, mindamage_override)
    duplicate("RAGE", "Other", "Accuracy boost", ui.new_combobox, "Off", "Low", "Medium", "High", "Maximum")
    duplicate("RAGE", "Other", "Quick stop", ui.new_checkbox)
    duplicate("RAGE", "Other", "Quick stop options", ui.new_multiselect, "Early", "Slow motion", "Duck", "Move between shots", "Ignore molotov")
	duplicate("RAGE", "Other", "Prefer body aim", ui.new_checkbox)
	duplicate("RAGE", "Other", "Prefer body aim disablers", ui.new_multiselect, "Low inaccuracy", "Target shot fired", "Target resolved", "Safe point headshot", "Low damage")
    duplicate("RAGE", "Other", "Delay shot on peek", ui.new_checkbox)
    
    ui.set_callback(config_ref, on_weapon_config_selected)
	ui.set_callback(enable_ref, on_adaptive_config_toggled)
    
    temp_task()
	on_adaptive_config_toggled(enable_ref)
end

init()