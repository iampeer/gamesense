--[[
    MIT License

    Copyright (c) peer 2020

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

-- <peer#0369>
-- version 1.0
-- last update 27.04.2020
-- allows having settings for multiple weapon groups within one configuration

-- credits: salvatore, nmchris, sapphyrus, aviarita and some others (not sure who'm)
-- if you see any code you've credit to, please contact me and i will refer to you

--/script variablies & constants
local weapon_info = {}
local weapon_names = {}
local active_key = "Other"
local cached_key

local cached_target
local visible = false

--/overrides for slider labels
local labels = {
    ["damage"] = {[0] = "Auto"},
    ["hitchance"] = {[0] = "Off"},
    ["mp"] = {[24] = "Auto"}
}

--/generate labels for HP+1-HP+126
local generate_damage_labels = function()
    for i = 1, 26 do 
        labels["damage"][100 + i] = "HP + " .. i
    end
end
generate_damage_labels()

--/comment or uncomment to disable/enable weapon groups
local weapon_indexes = {
    ["AWP"] = {9},
    ["Auto"] = {11, 38},
    ["Scout"] = {40},
    ["Revolver"] = {64},
    ["Deagle"] = {1},
    ["Pistol"] = {2, 3, 4, 30, 32, 36, 61, 63},
    ["Zeus"] = {31},
    --["Rifle"] = {7, 8, 10, 13, 16, 39, 60},
    --["Submachine gun"] = {17, 19, 24, 26, 33, 34},
    --["Heavy"] = {14, 28},
    --["Shotgun"] = {25, 27, 29, 35},
    ["Other"] = {}
    
}

local multipoint, _, mp_strenght = ui.reference("RAGE", "Aimbot", "Multi-point")

local reference = {
    selection = ui.reference("RAGE", "Aimbot", "Target selection"),
    hitbox = ui.reference("RAGE", "Aimbot", "Target hitbox"),
    multipoint = multipoint,
    multipoint_scale = ui.reference("RAGE", "Aimbot", "Multi-point scale"),
    dynamic = ui.reference("RAGE", "Aimbot", "Dynamic multi-point"),
    prefersafe = ui.reference("RAGE", "Aimbot", "Prefer safe point"),
    forcesafe_limbs = ui.reference("RAGE", "Aimbot", "Force safe point on limbs"),
    hit_chance = ui.reference("RAGE", "Aimbot", "Minimum hit chance"),
    damage = ui.reference("RAGE", "Aimbot", "Minimum damage"),
    boost = ui.reference("RAGE", "Other", "Accuracy boost"),
    delay = ui.reference("RAGE", "Other", "Delay shot"),
    stop = ui.reference("RAGE", "Other", "Quick stop"),
    stop_options = ui.reference("RAGE", "Other", "Quick stop options"),
    baim = ui.reference("RAGE", "Other", "Prefer body aim"),
    baim_disablers = ui.reference("RAGE", "Other", "Prefer body aim disablers"),
    baim_unduck = ui.reference("RAGE", "Other", "Delay shot on unduck"),
    baim_onpeek = ui.reference("RAGE", "Other", "Delay shot on peek"),
    doubletap = ui.reference("RAGE", "Other", "Double tap")
}

--/helpers
local multi_exec = function(func, list)
    if func == nil then return end
    
    for ref, val in pairs(list) do
        func(ref, val)
    end
end

local contains = function(tab, val)
    for i = 1, #tab do
        if tab[i] == val then
            return true
        end
    end
    
    return false
end

local fix_multiselect = function(multiselect, string)
    local number = ui.get(multiselect)
    if #number == 0 then
        ui.set(multiselect, string)
    end
end

--/get items from tables and put their keys in a seperate table
local get_items = function(tbl)
    local items = {}
    local n = 0

    for k,v in pairs(tbl) do
        n = n + 1
        items[n]=k
    end

    table.sort(items)
    return items
end

--/check if specific entity is in air
local in_air = function(ent)
    return (bit.band(entity.get_prop(ent, "m_fFlags"), 1) == 0)
end

--/get active weapon string 
--/example: returns 'Auto' when wielding either weapon idx 11 or 38
local get_key = function(val)
    for k, v in pairs(weapon_indexes) do
        if contains(v, val) then
            return k
        end
    end
    
    return "Other"
end

--/standalone controls
local controls = {
    active = "Other",
    visible = false,
    enabled = ui.new_checkbox("LUA", "A", "Enable adaptive weapons"),
    selected_weapon = ui.new_combobox("LUA", "A", "Selected weapon", get_items(weapon_indexes)),
    indicators = ui.new_checkbox("LUA", "A", "Display override indicators"),
    key_damage = ui.new_hotkey("LUA", "A", "Hotkey: damage override", false),
    key_hitbox = ui.new_hotkey("LUA", "A", "Hotkey: hitbox override", false),
    key_head = ui.new_hotkey("LUA", "A", "Hotkey: force head", false)
}

--/generate controls for each weapon group in weapon_indexes
local generate_weapon_controls = function()
    for name in pairs(weapon_indexes) do 
        weapon_info[name] = {
            selection = ui.new_combobox("LUA", "A", "[" .. name .. "] Target selection", {"Cycle"," Cycle (2x)", "Near crosshair", "Highest damage", "Lowest ping", "Best K/D ratio", "Best hit chance"}),
            hitbox = ui.new_multiselect("LUA", "A", "[" .. name .. "] Target hitbox", {"Head", "Chest", "Stomach", "Arms", "Legs", "Feet"}),
            hitbox_override = ui.new_multiselect("LUA", "A", "[" .. name .. "] Target hitbox override", {"Head", "Chest", "Stomach", "Arms", "Legs", "Feet"}),
            multipoint = ui.new_multiselect("LUA", "A", "[" .. name .. "] Multi-point", {"Head", "Chest", "Stomach", "Arms", "Legs", "Feet"}),
            multipoint_scale = ui.new_slider("LUA", "A", "[" .. name .. "] Multi-point scale", 24, 100, 50, true, "%", 1, labels.mp),
            dynamic = ui.new_checkbox("LUA", "A", "[" .. name .. "] Dynamic multi-point"),
            prefersafe = ui.new_checkbox("LUA", "A", "[" .. name .. "] Prefer safe point"),
            forcesafe_limbs = ui.new_checkbox("LUA", "A", "[" .. name .. "] Force safe point on limbs"),
            hit_chance = ui.new_slider("LUA", "A", "[" .. name .. "] Minimum hit chance", 0, 100, 55, true, "%", 1, labels.hitchance),
            damage = ui.new_slider("LUA", "A", "[" .. name .. "] Autowall damage", 0, 124, 15, true, "\n", 1, labels["damage"]),
            visible = ui.new_slider("LUA", "A", "[" .. name .. "] Minimum damage", 0, 124, 15, true, "\n", 1, labels["damage"]),
            damage_override = ui.new_slider("LUA", "A", "[" .. name .. "] Override minimum damage", 0, 124, 15, true, "\n", 1, labels["damage"]),
            in_air = ui.new_checkbox("LUA", "A", "[" .. name .. "] Customize values in-air"),
            hit_chance_air = ui.new_slider("LUA", "A", "[" .. name .. "] In-air hit chance", 0, 100, 34, true, "%", 1, labels.hitchance),
            damage_air = ui.new_slider("LUA", "A", "[" .. name .. "] In-air minimum damage", 0, 124, 20, true, "\n", 1, labels["damage"]),
            boost = ui.new_combobox("LUA", "A", "[" .. name .. "] Accuracy boost", { "Off", "Low", "Medium", "High", "Maximum" }),
            delay = ui.new_checkbox("LUA", "A", "[" .. name .. "] Delay shot"),
            stop = ui.new_checkbox("LUA", "A", "[" .. name .. "] Quick stop"),
            stop_options = ui.new_multiselect("LUA", "A", "[" .. name .. "] Quick stop options", { "Early", "Slow motion", "Duck", "Move between shots", "Ignore molotov" }),
            baim = ui.new_checkbox("LUA", "A", "[" .. name .. "] Prefer body aim"),
            baim_disablers = ui.new_multiselect("LUA", "A", "[" .. name .. "] Prefer body aim disablers", { "Low inaccuracy","Target shot fired","Target resolved","Safe point headshot","Low damage" }),
            baim_unduck = ui.new_checkbox("LUA", "A", "[" .. name .. "] Delay shot on unduck"),
            baim_onpeek = ui.new_checkbox("LUA", "A", "[" .. name .. "] Delay shot on peek"),
            doubletap = ui.new_checkbox("LUA", "A", "[" .. name .. "] Double tap"),
 		}
    end
end
generate_weapon_controls()

--/player visibility scanning
local vec2_dist = function(f_x, f_y, t_x, t_y)
    local delta_x, delta_y = f_x - t_x, f_y - t_y
    return math.sqrt(delta_x * delta_x + delta_y * delta_y)
end

local get_all_player_locations = function(ctx, w, h, enemy)
	local indexes = {}
	local positions = {}
	
	local players = entity.get_players(enemy)
	if #players == 0 then
		return
	end
	
	for i = 1, #players do
		local p = players[i]
		
		local px, py, pz = entity.get_prop(p, "m_vecOrigin")
		local vz = entity.get_prop(p,"m_vecViewOffset[2]")
		
		if pz ~= nil and vz ~= nil then
			pz = pz + (vz * 0.5)
			
			local sx, sy = client.world_to_screen(ctx, px, py, pz)
			
			if sx ~= nil and sy ~= nil then
				if sx >= 0 and sx < w and sy >= 0 and sy <= h then
                    indexes[#indexes+1] = p
                    positions[#positions+1] = {sx, sy}
                end
			end
		end
	end
	
	return indexes, positions
end

local check_fov = function(ctx)
    local w, h = client.screen_size()
    local sx, sy = w * 0.5, h * 0.5
    local fov_limit = 250 --/in pixels

    if get_all_player_locations(ctx, w, h, true) == nil then return end

    local enemy_indexes, enemy_coords = get_all_player_locations(ctx, w, h, true)

    if #enemy_indexes <= 0 then
        return true
    end

    if #enemy_coords == 0 then
        return true
    end

    local closest_fov = 133337
    local closest_entindex = 133337

    for i=1, #enemy_coords do
        local x = enemy_coords[i][1]
        local y = enemy_coords[i][2]

        local cur_fov = vec2_dist(x, y, sx, sy)
        if cur_fov < closest_fov then
            closest_fov = cur_fov
            closest_entindex = enemy_indexes[i]
        end
    end

    return closest_fov > fov_limit, closest_entindex
end

local can_see = function(ent)
    for i=0, 18 do
        if client.visible(entity.hitbox_position(ent, i)) then
            return true
        end
    end
    return false
end

--/main functions
local update_settings = function(weapon)
    if not ui.get(controls.enabled) then return end
    local active = weapon_info[weapon]

    --/update settings for rage settings
    for name, ref in pairs(reference) do
        ui.set(ref, ui.get(active[name]))

	    if name == "hitbox" then
            --/if "Hotkey: force head" is active
            --/set hitbox to 'Head'
            if ui.get(controls.key_head) then
                ui.set(ref, "Head")
            elseif ui.get(controls.key_damage) then
                --/if 'Hotkey: hitbox override' is active
                --/set hitboxes to value in 'target hitbox override'
                ui.set(ref, ui.get(active["hitbox_override"]))
            end
        end
		
        if name == "damage" then
            if in_air(entity.get_local_player()) and ui.get(active["in_air"]) then
                --/if local player is in air and customize values in-air is enabled
                --/set hit chance to value in 'minimum damage in-air'
                ui.set(ref, ui.get(active["damage_air"]))
            elseif visible and not ui.get(controls.key_damage) then
                --/if enemy is visible and 'Hotkey: damage override' not is active
                ui.set(ref, ui.get(active["visible"]))
            elseif ui.get(controls.key_damage) then
                --/if 'Hotkey: damage override' is active
                --/set minimum damage to value in 'override damage'
                ui.set(ref, ui.get(active["damage_override"]))
            end
        end

        if name == "hit_chance" then
            if in_air(entity.get_local_player()) and ui.get(active["in_air"]) then
                --/if local player is in air and customize values in-air is enabled
                --/set hit chance to value in 'hit chance in-air'
                ui.set(ref, ui.get(active["hit_chance_air"]))
            end
        end
    end
end

--/menu handling
local bind_callback = function(list, callback, elem)
    for k in pairs(list) do
        if type(list[k]) == "table" and list[k][elem] ~= nil then
            ui.set_callback(list[k][elem], callback)
        end
    end
end

local menu_callback = function(e, menu_call)
    local setup_weapon_controls = function(list, selected_weapon, vis)
        local control_ref = weapon_info[selected_weapon]

        for k, v in pairs(list) do
            local active = k == selected_weapon
            local mode = list[k]

            if type(mode) == "table" then
                for j in pairs(mode) do
                    local set_element = true

                    local mp = ui.get(mode["multipoint"])
                    local baim = ui.get(mode["baim"])
                    local stop = ui.get(mode["stop"])
                    local air = ui.get(mode["in_air"])

                    if not next(mp) and (active and j == "dynamic" or j == "multipoint_scale") then set_element = false end
                    if not air and (active and j == "hit_chance_air" or j == "damage_air") then set_element = false end
                    if not stop and (active and j == "stop_options") then set_element = false end
                    if not baim and (active and j == "baim_disablers" or j == "baim_unduck" or j == "baim_onpeek") then set_element = false end

                    ui.set_visible(mode[j], active and vis and set_element)
                end
            end
        end
    end

    local state = not ui.get(controls.enabled)
    if e == nil then state = true end

    if menu_call == nil then
        setup_weapon_controls(weapon_info, ui.get(controls.selected_weapon), not state)
    end

    multi_exec(ui.set_visible, {
        [controls.selected_weapon] = not state,
        [controls.indicators] = not state,
        [controls.key_damage] = not state,
        [controls.key_hitbox] = not state,
        [controls.key_head] = not state
    })
end

menu_callback(controls.enabled)
bind_callback(weapon_info, menu_callback, "multipoint")
bind_callback(weapon_info, menu_callback, "in_air")
bind_callback(weapon_info, menu_callback, "stop")
bind_callback(weapon_info, menu_callback, "baim")

ui.set_callback(controls.enabled, menu_callback)
ui.set_callback(controls.selected_weapon, menu_callback)

--/handle updating weapon settings according to wielded weapon
client.set_event_callback("net_update_end", function()
    if not ui.get(controls.enabled) then return end
    if entity.get_prop(entity.get_local_player(), "m_lifeState") ~= 0 or not entity.get_local_player() then return end

    local player_weapon = entity.get_player_weapon(entity.get_local_player())
    local weapon_index = bit.band(65535, entity.get_prop(player_weapon, "m_iItemDefinitionIndex"))

    active_key = get_key(weapon_index)
    local temp = weapon_info[active_key]

    --/fill hitbox and hitbox_override with atleast one hitbox due to target hitbox always requiring
    --/one or more values
    fix_multiselect(temp["hitbox"], "Head")
    fix_multiselect(temp["hitbox_override"], "Head")

    update_settings(active_key)
    cached_key = active_key
end)

--/handle player visibility for visible minimum damage
client.set_event_callback("paint", function(ctx)
    if not ui.get(controls.enabled) then return end

    local local_player = entity.get_local_player()
	if entity.get_prop(local_player, "m_lifeState") ~= 0 then	
		visible = false
		return
    end

    local temp = weapon_info[active_key]

    --/make sure to not do visibility calculations when 'damage' and 'visible'
    --/are set to the same value
    if temp ~= nil and ui.get(temp["damage"]) ~= ui.get(temp["visible"]) then
        local enemy_visible, enemy_entindex = check_fov(ctx)
        if enemy_entindex == nil then return end
        if enemy_visible and enemy_entindex ~= nil and cached_target ~= enemy_entindex then 
            cached_target = enemy_entindex
        end

        local _ = can_see(enemy_entindex)
        if _ then 
            visible = true
        else 
            visible = false
        end

        cached_target = enemy_entindex
    else
        return
    end
end)

--/handle indicator drawing
client.set_event_callback("paint", function(ctx)
    if not ui.get(controls.enabled) then return end
    if not ui.get(controls.indicators) then return end

    if ui.get(controls.key_head) then
        renderer.indicator(255, 50, 50, 255, "HEAD")
    end 
    if ui.get(controls.key_damage) then
        renderer.indicator(150, 200, 60, 255, "DMG")
    end
    if ui.get(controls.key_hitbox) then
        renderer.indicator(150, 200, 60, 255, "HB")
    end
end)