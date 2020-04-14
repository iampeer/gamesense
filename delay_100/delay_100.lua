local _debug = false

local location = { "LUA", "B" }
local key

--/weapon table
local weapons = {
	["Auto"] = {11,38},
	["Awp"] = {9},
	["Scout"] = {40},
	["Revolver"] = {64},
	--["Pistol"] = {2, 3, 4, 30, 32, 36, 61, 63},
    --["Rifle"] = {7, 8, 10, 13, 16, 39, 60},
    --["Desert Eagle"] = { 1 },
    --["Submachine gun"] = {17, 19, 24, 26, 33, 34},
    --["Heavy"] = {14, 28},
    --["Shotgun"] = {25, 27, 29, 35}
}

--/references to menu controls
local reference = {
	damage = ui.reference("RAGE", "Aimbot", "Minimum damage"),
	delay = ui.reference("RAGE", "Other", "Delay shot")
}

--/new script controls
local interface = {
	enabled = ui.new_checkbox(location[1], location[2], "Delay on-shot"),
	damage = ui.new_checkbox(location[1], location[2], "Delay on-shot 100 min. damage"),
	air = ui.new_checkbox(location[1], location[2], "Delay on-shot ignore in air"),
	weapons = ui.new_multiselect(location[1], location[2], "Delay on-shot weapons", {
		"Auto",
		"Awp",
		"Scout",
		"Revolver",
		--"Pistol",
    	--"Rifle",
    	--"Desert Eagle",
    	--"Submachine gun",
    	--"Heavy",
    	--"Shotgun"
	}),
}

--/helper functions
local contains = function(tab, val)
    for i = 1, #tab do
        if tab[i] == val then
            return true
        end
    end
    return false
end

local multi_exec = function(func, list)
    if func == nil then return end
    
    for ref, val in pairs(list) do
        func(ref, val)
    end
end

local function vec2_distance(x1, y1, z1, x2, y2, z2)
	return math.sqrt((x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2)
end

--/script functions
local get_closest_entity = function()
    local me = entity.get_local_player()
	local entities = entity.get_players(true) --/true for enemies only
    
	local lx, ly, lz = entity.get_prop(me, "m_vecOrigin") --/get local position
    local closest_ent, closest_distance = nil, math.huge

    for i=1, #entities do
		local ex, ey, ez = entity.get_prop(entities[i], "m_vecOrigin")
		local distance = vec2_distance(lx, ly, lz, ex, ey, ez)
      
		if distance <= closest_distance then
			closest_ent = entities[i]
			closest_distance = distance
		end
	end
	
    return closest_ent
end
 
local get_weapon_idx = function(val)
    for k, v in pairs(weapons) do
        if contains(v, val) then
            return k
        end
    end
    return "Other"
end
 
 local get_player_weapon = function(e)
	local weapon = entity.get_player_weapon(e)
	return (bit.band(65535, entity.get_prop(weapon, "m_iItemDefinitionIndex")))
 end
 
 local update_settings = function()
	local enemy_entindex = get_closest_entity()
	if enemy_entindex == nil or entity.get_prop(enemy_entindex, "m_lifeState") ~= 0 then
		if _debug then client.log("delay_100: no enemy found") end
		ui.set(reference.delay, false)
		return
	end
	
	local on_ground = bit.band(entity.get_prop(enemy_entindex, "m_fFlags"), 1)
	if ui.get(interface.air) and on_ground == 0 then
		if _debug then 
			client.log("delay_100: ignore in air active")
			client.log("delay_100: " .. entity.get_player_name(enemy_entindex) .. " is in air")
		end
		ui.set(reference.delay, false)
		return
	end
	
	if ui.get(interface.damage) and ui.get(reference.damage) < 99 then
		if _debug then client.log("delay_100: 100 damage active, but minimum damage is not above 100") end
		ui.set(reference.delay, false)
		return
	end
	
	if entity.get_prop(enemy_entindex, "m_iHealth") < 92 then
		if _debug then client.log("delay_100: enemy is baimable") end
		ui.set(reference.delay, false)
		return
	end
	
	if _debug then client.log("delay_100: delay enabled") end
	ui.set(reference.delay, true)
 end

--/menu handling
local handle_visibility = function()
	local state = ui.get(interface.enabled)
	
	multi_exec(ui.set_visible, {
		[interface.weapons] = state,
		[interface.damage] = state,
		[interface.air] = state
	})
end
handle_visibility()
ui.set_callback(interface.enabled, handle_visibility)

--/events
client.set_event_callback("setup_command", function(e)
	ui.set(reference.delay, false)
	
	if not ui.get(interface.enabled) then return end
	local me = entity.get_local_player()
	
	key = get_weapon_idx(get_player_weapon(me))

	if key ~= "Other" or not next(ui.get(interface.weapons)) then
		if contains(ui.get(interface.weapons), key) then
			update_settings()
		end
	end
end)

client.register_esp_flag("DELAY",150, 200, 60, function(e)
	return e == get_closest_entity() and ui.get(reference.delay)
end)