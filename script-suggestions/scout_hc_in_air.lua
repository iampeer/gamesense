-- SCRIPT SUGGESTION
-- ADJUSTABLE HC IN AIR FOR JUMP SCOUTING
--
-- peer#5722

local scout_wep_id = 40

local off_hc_on_zero = function()
    local hc_zero = "Off"

    return hc_zero
end

local function fl_onground(ent)
    local flags = entity.get_prop(ent, "m_fFlags")
    local flags_on_ground = bit.band(flags, 1)

    if flags_on_ground == 1 then
        return true
    end
    return false
end

local function weapon_id(ent)
    local weapon = entity.get_player_weapon(ent)
    local weapon_id = bit.band(entity.get_prop(weapon, "m_iItemDefinitionIndex"), 0xFFFF)

    return weapon_id
end

local data =  {
    cached_hc = nil,
    minimum_hc = ui.reference("RAGE", "Aimbot", "Minimum hit chance"),

    enable = ui.new_checkbox(
        "RAGE", "Aimbot", "Hit chance in-air (scout)"
    ),

    hc_value = ui.new_slider(
        "RAGE", "Aimbot", "In-air minimum hit chance", 0, 100, 50, true, "%", 1, off_hc_on_zero()
    )
}

data.set_visible = function(_self)
    if not _self then
        ui.set_callback(data.enable, data.set_visible)
    end

    ui.set_visible(data.hc_value, ui.get(data.enable))
end

data.callback = function()
    data.cached_hc = data.cached_hc ~= nil and data.cached_hc or ui.get(data.minimum_hc)

    if ui.get(data.enable) and not fl_onground(entity.get_local_player()) and weapon_id(entity.get_local_player()) == scout_wep_id then
        ui.set(data.minimum_hc, ui.get(data.hc_value))
    else
        if data.cached_hc ~= nil then
            ui.set(data.minimum_hc, data.cached_hc)
            data.cached_hc = nil
        end
    end
end

data.set_visible()
client.set_event_callback("paint", data.callback)