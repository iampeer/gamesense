local change = false
local stored_target = nil

local set_dmg_list = function()
    local damage_list = { }

    damage_list[0] = "Auto"

    for i = 1, 26 do
        -- HP + {1-26}
        -- HP = 0 -> Auto
    
        damage_list[100 + i] = "HP+" .. i
    end

    return damage_list
end

local ref_min_dmg = ui.reference("Rage", "Aimbot", "Minimum damage")
local override_key = ui.new_hotkey("Rage", "Aimbot", "On key override")
local override_dmg = ui.new_slider("Rage", "Aimbot", "Override minimum damage", 0, 126, 0, true, "%", 1, set_dmg_list())



local function changed(c)
    local h_key = ui.get(override_key)
    local dmg_slider_ref = ui.get(override_dmg)
    
    if h_key and change == false then
        stored_dmg = ui.get(ref_min_dmg)
        ui.set(ref_min_dmg, dmg_slider_ref)
        change = true
    elseif not h_key and change == true then
        ui.set(ref_min_dmg, stored_dmg)
        change = false
    end	
end

client.set_event_callback("paint", changed)
