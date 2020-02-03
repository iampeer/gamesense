local r_strafe = ui.reference("MISC", "Movement", "Air strafe")
local active = ui.new_checkbox("MISC", "Movement", "Disable air strafe on nade")

local function on_ground(ent)
    local flags = entity.get_prop( ent, "m_fFlags" )
    local flags_on_ground = bit.band( flags, 1 )

    if flags_on_ground == 1 then
        return true
	end	
	
    return false
end

client.set_event_callback("setup_command", function(c)
	if ui.get(active) ~= true then
		return
	end

	local me = entity.get_local_player()
	local weapon = entity.get_player_weapon(me)

	if me == nil or weapon == nil then
		return
	end

	local weapon_id = bit.band(entity.get_prop(weapon, "m_iItemDefinitionIndex"), 0xFFFF)

	if weapon_id > 42 and weapon_id < 49 and not on_ground(me) then
		ui.set(r_strafe, false)
		return
	end

	ui.set(r_strafe, true)
end)