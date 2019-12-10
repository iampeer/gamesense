-- SCRIPT SUGGESTION
-- ON KEY TOGGLE SLOW MOTION TYPE
--
-- peer#5722

local switch_hk = ui.new_hotkey("AA", "Other", "Switch slow motion type")

local slowmo, slowmo_hk = ui.reference("AA", "Other", "Slow motion")
local slowmo_type = ui.reference("AA", "Other", "Slow motion type")

local doubletap, dt_key = ui.reference("Rage", "Other", "Double tap")


local set_type = ui.get(slowmo_type)

client.set_event_callback("paint", function(ctx)
    local doubletapping = ui.get(dt_key) and true or false

    if ui.get(switch_hk) and set_type == "Favor high speed" and not doubletapping  then
        ui.set(slowmo_type, "Favor anti-aim")
    else
        ui.set(slowmo_type, "Favor high speed")
    end
end)