--#region Dependencies
--#region Api
local ClientUnsetEventCallback, ClientUserIDToEntIndex, ClientSetEventCallback, ClientScreenSize, ClientTraceBullet, ClienUnsetEventCallback, ClientColorLog, ClientReloadActiveScripts, ClientScaleDamage, ClientGetCvar, ClientCameraPosition, ClientCreateInterface, ClientRandomInt, ClientLatency, ClientSetClanTag, ClientFindSignature, ClientLog, ClientTimestamp, ClientDelayCall, ClientTraceLine, ClientRegisterEspFlag, ClientGetModelName, ClientSystemTime, ClientVisible, ClientExec, ClientKeyState, ClientSetCvar, ClientUnixTime, ClientErrorLog, ClientDrawDebugText, ClientUpdatePlayerList, ClientCameraAngles, ClientEyePosition, ClientDrawHitboxes, ClientRandomFloat = client.unset_event_callback, client.userid_to_entindex, client.set_event_callback, client.screen_size, client.trace_bullet, client.unset_event_callback, client.color_log, client.reload_active_scripts, client.scale_damage, client.get_cvar, client.camera_position, client.create_interface, client.random_int, client.latency, client.set_clan_tag, client.find_signature, client.log, client.timestamp, client.delay_call, client.trace_line, client.register_esp_flag, client.get_model_name, client.system_time, client.visible, client.exec, client.key_state, client.set_cvar, client.unix_time, client.error_log, client.draw_debug_text, client.update_player_list, client.camera_angles, client.eye_position, client.draw_hitboxes, client.random_float
local EntityGetLocalPlayer, EntityIsEnemy, EntityGetBoundingBox, EntityGetAll, EntitySetProp, EntityIsAlive, EntityGetSteam64, EntityGetClassName, EntityGetPlayerResource, EntityGetESPData, EntityIsDormant, EntityGetPlayerName, EntityGetGameRules, EntityGetOrigin, EntityHitboxPosition, EntityGetPlayerWeapon, EntityGetPlayers, EntityGetProp = entity.get_local_player, entity.is_enemy, entity.get_bounding_box, entity.get_all, entity.set_prop, entity.is_alive, entity.get_steam64, entity.get_classname, entity.get_player_resource, entity.get_esp_data, entity.is_dormant, entity.get_player_name, entity.get_game_rules, entity.get_origin, entity.hitbox_position, entity.get_player_weapon, entity.get_players, entity.get_prop
local GlobalsRealtime, GlobalsAbsoluteTimeframe, GlobalsChokedCommands, GlobalsOldCommandAck, GlobalsTickcount, GlobalsCommandAck, GlobalsLastOutgoingCommand, GlobalsCurtime, GlobalsMapname, GlobalsTickInterval, GlobalsFramecount, GlobalsFrametime, GlobalsMaxPlayers = globals.realtime, globals.absoluteframetime, globals.chokedcommands, globals.oldcommandack, globals.tickcount, globals.commandack, globals.lastoutgoingcommand, globals.curtime, globals.mapname, globals.tickinterval, globals.framecount, globals.frametime, globals.maxplayers
local UINewSlider, UINewCombobox, UIReference, UISetVisible, UINewTextbox, UINewColorPicker, UINewCheckbox, UIMousePosition, UINewListbox, UINewMultiselect, UIMenuOpen, UINewHotkey, UISet, UIUpdate, UIMenuSize, UIName, UIMenuPosition, UISetCallback, UINewButton, UINewLabel, UINewString, UIGet = ui.new_slider, ui.new_combobox, ui.reference, ui.set_visible, ui.new_textbox, ui.new_color_picker, ui.new_checkbox, ui.mouse_position, ui.new_listbox, ui.new_multiselect, ui.is_menu_open, ui.new_hotkey, ui.set, ui.update, ui.menu_size, ui.name, ui.menu_position, ui.set_callback, ui.new_button, ui.new_label, ui.new_string, ui.get
local RendererGetTextSize, RendererDrawLocalizedText, RendererCircleOutline, RendererWorldToScreen, RendererLine, RendererDrawOutlinedRect, RendererLoadRGBA, RendererTexture, RendererDrawText, RendererTestFont, RendererGradient, RendererDrawFilledRect, RendererDrawFilledOutlinedRect, RendererLoadSVG, RendererLocalizeString, RendererSetMousePos, RendererLoadJPG, RendererUnlockCursor, renderer_load_png, renderer_draw_poly_line, RendererCreateFont, RendererTriangle, RendererRectangle, RendererGetMousePos, RendererText, RendererCircle, RendererIndicator, RendererDrawFilledGradientRect, RendererDrawLine, RendereMeasureText, RendererLoadTexture, RendererDrawOutlinedCircle, RendererLockCursor = renderer.get_text_size, renderer.draw_localized_text, renderer.circle_outline, renderer.world_to_screen, renderer.line, renderer.draw_outlined_rect, renderer.load_rgba, renderer.texture, renderer.draw_text, renderer.test_font, renderer.gradient, renderer.draw_filled_rect, renderer.draw_filled_outlined_rect, renderer.load_svg, renderer.localize_string, renderer.set_mouse_pos, renderer.load_jpg, renderer.unlock_cursor, renderer.load_png, renderer.draw_poly_line, renderer.create_font, renderer.triangle, renderer.rectangle, renderer.get_mouse_pos, renderer.text, renderer.circle, renderer.indicator, renderer.draw_filled_gradient_rect, renderer.draw_line, renderer.measure_text, renderer.load_texture, renderer.draw_outlined_circle, renderer.lock_cursor
local MathCeil, MathTan, MathCos, MathSinh, MathPI, MathMax, MathAtan2, MathFloor, MathSqrt, MathDeg, MathAtan, MathFmod, MathAcos, MathPow, MathAbs, MathMin, MathSin, MathLog, MathExp, MathCosh, MathAsin, MathRad = math.ceil, math.tan, math.cos, math.sinh, math.pi, math.max, math.atan2, math.floor, math.sqrt, math.deg, math.atan, math.fmod, math.acos, math.pow, math.abs, math.min, math.sin, math.log, math.exp, math.cosh, math.asin, math.rad
local TableClear, TableSort, TableRemove, TableConcat, TableInsert, BitBand = table.clear, table.sort, table.remove, table.concat, table.insert, bit.band
local StringFind, StringFormat, StringLen, StringGsub, StringGmatch, StringMatch, StringReverse, StringUpper, StringLower, StringSub = string.find, string.format, string.len, string.gsub, string.gmatch, string.match, string.reverse, string.upper, string.lower, string.sub
--#endregion
--#endregion

--#region Variables & Constants
local Menu = { "lua", "A" }

local WeaponGroups, WeaponInfo = {}, {}
local ActiveKey
local CachedKey = "Global"

local Labels = {
    Damage = { [0] = "Auto" },
    HitChance = { [0] = "Off" },
    Multipoint = { [24] = "Auto" }
}

local Exceptions = {
    "CKnife",
    "CSmokeGrenade",
    "CFlashbang",
    "CHEGrenade",
    "CDecoyGrenade",
    "CIncendiaryGrenade",
    "CMolotovGrenade",
    "CC4"
}

local DoubletapKeyMode = "Toggle"
local FreestandingKeyMode = "Toggle"

local function GenerateLabels() for I = 1, 26 do Labels.Damage[100 + I] = StringFormat("HP + %s", I) end end
GenerateLabels()
--#endregion

--#region Helpers & Utility

local Helpers = {
    Contains = function(tab, val)
        for I=1, #tab do
            if tab[I] == val then
                return true
            end
        end
        
        return false
    end,
    MultiExecute = function(func, list)
        if func == nil then
            return
        end
    
        for R, V in pairs(list) do
            func(R, V)
        end
    end,
    FixMultiselect = function(elem, value)
        local Num = UIGet(elem)
    
        if #Num == 0 then
            UISet(elem, value)
        end
    end
}

local MathHelpers = {
    DistanceTo = function(xyz1, xyz2)
        local From = MathSqrt(xyz1[1]*xyz1[1]) + MathSqrt(xyz1[2]*xyz1[2]) + MathSqrt(xyz1[3]*xyz1[3])
        local To = MathSqrt(xyz2[1]*xyz2[1]) + MathSqrt(xyz2[2]*xyz2[2]) + MathSqrt(xyz2[3]*xyz2[3])

        return (From - To)
    end,
    UnitsToFeet = function(units)
        local Meters = MathFloor((units * 0.0254) + 0.5)
    
        return MathFloor((Meters * 3.281) + 0.5)
    end,
    OnGround = function(entindex)
        return (BitBand(EntityGetProp(entindex, "m_fFlags"), 1) ~= 0)
    end
}

local WeaponHelpers = {
    GetWeaponGroups = function()
        local N = 1
        local TempTab = {}
    
        for K, _ in pairs(WeaponGroups) do
            TempTab[N] = K
             N = N + 1
        end
    
        return TempTab
    end,
    GetWeaponKey = function(idx)
        for K, V in pairs(WeaponGroups) do
            if Helpers.Contains(V, idx) then
                return K
            end
        end
        return "Global"
    end
}
--#endregion
--#region Entity Functions
local function HitboxVisible(entindex, secure)
    if secure == nil or secure then
        secure = 8;
    else
        secure = 18;
    end


    for i=0, secure do
        local HitboxPos = { EntityHitboxPosition(entindex, i) }
        if ClientVisible(HitboxPos[1], HitboxPos[2], HitboxPos[3]) then
            return true
        end
    end

    return false;
end

local function PlayerVisible()
    local Players = EntityGetPlayers(true)

    if #Players == 0 then
        return
    end

    for i=1, #Players do
        if(HitboxVisible(Players[i])) then
            return true
        end
    end

    return false
end

local function GetClosestEnemy()
    local LocalOrigin = { EntityGetOrigin(EntityGetLocalPlayer()) }
    local NearestDistance, NearestEntity
    local Players = EntityGetPlayers(true)

    if #Players == 0 then
        return
    end

    for i=1, #Players do
        local Player = Players[i]

        local TargetOrigin = { EntityGetOrigin(Player) }
        local DistanceToTarget = MathHelpers.DistanceTo(LocalOrigin, TargetOrigin)

        if NearestDistance == nil or DistanceToTarget < NearestDistance then
            NearestEntity = Player
            NearestDistance = DistanceToTarget
        end

        if NearestDistance and NearestEntity then
            return NearestEntity, MathHelpers.UnitsToFeet(NearestDistance)
        end
    end

    return nil, 0
end
--#endregion
--#region Menu & References
local Ctrl = { 
    MasterSwitch = UINewCheckbox(Menu[1], Menu[2], "Adaptive weapons"),
    MasterColor = UINewColorPicker(Menu[1], Menu[2], "global_clr", 255, 255, 255, 255),
    NoscopeKey = UINewHotkey(Menu[1], Menu[2], "Noscope override key"),
    DamageKey = UINewHotkey(Menu[1], Menu[2], "Damage override key"),
    CurrentWeapon
}

local   Multipoint, _, MpStrenght = UIReference("rage", "Aimbot", "Multi-point")

local Reference = {
    Selection = UIReference("rage", "Aimbot", "Target selection"),
    Hitbox = UIReference("rage", "Aimbot", "Target hitbox"),
    Multipoint = Multipoint,
    MultipointScale = UIReference("rage", "Aimbot", "Multi-point scale"),
    PreferSafe = UIReference("rage", "Aimbot", "Prefer safe point"),
    ForceSafeLimbs = UIReference("rage", "Aimbot", "Force safe point on limbs"),
    HitChance = UIReference("rage", "Aimbot", "Minimum hit chance"),
    Damage = UIReference("rage", "Aimbot", "Minimum damage"),
    Boost = UIReference("rage", "Other", "Accuracy boost"),
    Delay = UIReference("rage", "Other", "Delay shot"),
    Stop = UIReference("rage", "Other", "Quick stop"),
    StopOptions = UIReference("rage", "Other", "Quick stop options"),
    BaimPeek = UIReference("rage", "Other", "Force body aim on peek"),
    Baim = UIReference("rage", "Other", "Prefer body aim"),
    BaimDisablers = UIReference("rage", "Other", "Prefer body aim disablers"),
    Doubletap = UIReference("rage", "Other", "Double tap"),
    DoubletapStop = UIReference("rage", "Other", "Double tap quick stop"),
    AutoScope = UIReference("rage", "Aimbot", "Automatic scope"),
    AutoPenetration = UIReference("rage", "Aimbot", "Automatic penetration"),
    SilentAim = UIReference("rage", "Aimbot", "Silent aim"),
    AutoFire = UIReference("rage", "Aimbot", "Automatic fire")
}

local FakeDuckRef = UIReference("rage", "Other", "Duck peek assist")
local DoubletapRef = { UIReference("rage", "Other", "Double tap") }
local QuickPeekRef = { UIReference("rage", "Other", "Quick peek assist") }
local FreestandingRef = { UIReference("aa", "Anti-aimbot angles", "Freestanding") }

local function GenerateWeaponControls()
    for Name in pairs(WeaponGroups) do 
        WeaponInfo[Name] = {
            Enabled = UINewCheckbox(Menu[1], Menu[2], StringFormat("[%s] Enabled", Name)),
            Selection = UINewCombobox(Menu[1], Menu[2], StringFormat("[%s] Target selection", Name), {"Cycle","Cycle (2x)", "Near crosshair", "Highest damage", "Lowest ping", "Best K/result ratio", "Best hit chance"}),
            Hitbox = UINewMultiselect(Menu[1], Menu[2], StringFormat("[%s] Target hitbox", Name), {"Head", "Chest", "Stomach", "Arms", "Legs", "Feet"}),
            Multipoint = UINewMultiselect(Menu[1], Menu[2], StringFormat("[%s] Multi-point", Name), {"Head", "Chest", "Stomach", "Arms", "Legs", "Feet"}),
            MultipointScale = UINewSlider(Menu[1], Menu[2], StringFormat("[%s] Multi-point scale", Name), 24, 100, 65, true, "%", 1, Labels.Multipoint),
            PreferSafe = UINewCheckbox(Menu[1], Menu[2], StringFormat("[%s] Prefer safe point", Name)),
            ForceSafeLimbs = UINewCheckbox(Menu[1], Menu[2], StringFormat("[%s] Force safe point on limbs", Name)),
            HitChance = UINewSlider(Menu[1], Menu[2], StringFormat("[%s] Minimum hit chance", Name), 0, 100, 60, true, "%", 1, Labels.HitChance),
            Damage = UINewSlider(Menu[1], Menu[2], StringFormat("[%s] Minimum damage", Name), 0, 124, 20, true, "\n", 1, Labels.Damage),
            Visible = UINewSlider(Menu[1], Menu[2], StringFormat("[%s] Visible damage", Name), 0, 124, 20, true, "\n", 1, Labels.Damage),
            DamageOverride = UINewSlider(Menu[1], Menu[2], StringFormat("[%s] Override damage", Name), 0, 124, 20, true, "\n", 1, Labels.Damage),
            AutoFire = UINewCheckbox(Menu[1], Menu[2], StringFormat("[%s] Automatic fire", Name)),
            AutoPenetration = UINewCheckbox(Menu[1], Menu[2], StringFormat("[%s] Automatic penetration", Name)),
            AutoScope = UINewCheckbox(Menu[1], Menu[2], StringFormat("[%s] Automatic scope", Name)),
            HitChanceNoscope = UINewSlider(Menu[1], Menu[2], StringFormat("[%s] Minimum noscope hit chance", Name), 0, 100, 60, true, "%", 1, Labels.HitChance),
            InAir = UINewCheckbox(Menu[1], Menu[2], StringFormat("[%s] Hit chance in air", Name)),
            InAirHitChance = UINewSlider(Menu[1], Menu[2], StringFormat("[%s] Air hit chance", Name), 0, 100, 30, true, "%", 1, Labels.HitChance),
            Boost = UINewCombobox(Menu[1], Menu[2], StringFormat("[%s] Accuracy boost", Name), { "Off", "Low", "Medium", "High", "Maximum" }),
            Delay = UINewCheckbox(Menu[1], Menu[2], StringFormat("[%s] Delay shot", Name)),
            Stop = UINewCheckbox(Menu[1], Menu[2], StringFormat("[%s] Quick stop", Name)),
            StopOptions = UINewMultiselect(Menu[1], Menu[2], StringFormat("[%s] Quick stop options", Name), { "Early", "Slow motion", "Fake duck", "Duck", "Move between shots", "Ignore molotov" }),
            BaimPeek = UINewCheckbox(Menu[1], Menu[2], StringFormat("[%s] Force body aim on peek", Name)),
            Baim = UINewCheckbox(Menu[1], Menu[2], StringFormat("[%s] Prefer body aim", Name)),
            BaimDisablers = UINewMultiselect(Menu[1], Menu[2], StringFormat("[%s] Prefer body aim disablers", Name), { "Low inaccuracy","Target shot fired","Target resolved","Safe point headshot","Low damage" }),
            Doubletap = UINewCheckbox(Menu[1], Menu[2], StringFormat("[%s] Double tap", Name)),
            DoubletapStop = UINewMultiselect(Menu[1], Menu[2], StringFormat("[%s] Double tap quick stop", Name), { "Slow motion", "Duck", "Move between shots" }),
            Noscope = UINewCheckbox(Menu[1], Menu[2], StringFormat("[%s] Noscope", Name)),
            NoscopeDistance = UINewSlider(Menu[1], Menu[2], StringFormat("[%s] Noscope distance", Name), 0, 100, 40, true, "ft"),
        }
    end
end
--#endregion
--#region Main Functions
local function DoNoscope(key)
    local Me = EntityGetLocalPlayer()

    local WpnDist = UIGet(WeaponInfo[key].NoscopeDistance)
    local Data = { GetClosestEnemy() }
    local IsScoped = EntityGetProp(Me, "m_bIsScoped") ~= 0 and true or false

    if Data[1] ~= nil and Data[2] < WpnDist and not IsScoped then
        return true
    end

    return false
end

local function UpdateSettings(key)
    local Active = WeaponInfo[key]

    local Run = function()
        for Name, Ref in pairs(Reference) do
            if Name ~= nil and Active[Name] ~= nil then
                UISet(Ref, UIGet(Active[Name]))
            end

            if Name == "Damage" then
                local FinalDamage = UIGet(Active.Damage)
                local DamageKey = UIGet(Ctrl.DamageKey)
                
                if UIGet(FakeDuckRef) and not DamageKey then
                    FinalDamage = FinalDamage
                elseif PlayerVisible() and UIGet(Active.Visible) ~= UIGet(Active.Damage) and not DamageKey then
                    FinalDamage = UIGet(Active.Visible)
                elseif DamageKey then
                    FinalDamage = UIGet(Active.DamageOverride)
                end
    
                UISet(Ref, FinalDamage)
            end

            if UIGet(Active.Noscope) then
                if UIGet(Ctrl.NoscopeKey) then
                    UISet(Reference.AutoScope, true)
                else
                    local Result = DoNoscope(key)
                    if DoNoscope(key) then
                        UISet(Reference.AutoScope, UIGet(Active.AutoScope))
                    end
                end
            else
                UISet(Reference.AutoScope, UIGet(Active.AutoScope))
            end
    
            if Name == "HitChance" then
                local FinalHitChance = UIGet(Active.HitChance)
    
                if UIGet(Active.InAir) and not MathHelpers.OnGround(EntityGetLocalPlayer()) then
                    FinalHitChance = UIGet(Active.InAirHitChance)
                elseif UIGet(Active.Noscope) then
                    FinalHitChance = UIGet(Active.HitChanceNoscope)
                end
    
                UISet(Ref, FinalHitChance)
            end
        end
    end

    Run()
end
--#endregion
--#region Menu Callbacks
local function BindCallback(list, callback, elem)
    for K in pairs(list) do
        if type(list[K] == "table" and list[K][elem] ~= nil) then
            UISetCallback(list[K][elem], callback)
        end
    end
end

local function MenuCallback(e, call)
    local SetupMenu = function(list, current, visible)
        for K in pairs(list) do
            local Mode = list[K]
            local Active = K == current

            if type(Mode) == 'table' then
                for J in pairs(Mode) do
                    
                    local SetElement = true

                    if not next(UIGet(Mode.Multipoint)) and (Active and J == "MultipointScale") then
                        SetElement = false
                    end

                    if not UIGet(Mode.Baim) and (Active and J == "BaimDisablers") then
                        SetElement = false
                    end

                    if not UIGet(Mode.InAir) and (Active and J == "InAirHitChance") then
                        SetElement = false
                    end

                    if not UIGet(Mode.Stop) and (Active and J == "StopOptions") then
                        SetElement = false
                    end

                    if not UIGet(Mode.Noscope) and (Active and J == "NoscopeDistance") then
                        SetElement = false
                    end

                    if not UIGet(Mode.Doubletap) and (Active and J == "DoubletapStop") then
                        SetElement = false
                    end

                    Helpers.FixMultiselect(Mode.Hitbox, "Head")
                    Helpers.FixMultiselect(Mode.Multipoint, "Head")

                    UISetVisible(Mode[J], Active and visible and SetElement)
                end
            end
        end
    end

    local State = not UIGet(Ctrl.MasterSwitch)

    if e == nil then
        State = true
    end

    if call == nil then
        SetupMenu(WeaponInfo, UIGet(Ctrl.CurrentWeapon), not State)
    end

    Helpers.MultiExecute(UISetVisible, {
        [Ctrl.MasterColor] = not State,
        [Ctrl.DamageKey] = not State,
        [Ctrl.NoscopeKey] = not State,
        [Ctrl.CurrentWeapon] = not State
    })
end
--#endregion
--#region Callbacks
local function OnRunning(c)
    local LocalPlayer = EntityGetLocalPlayer()

    if LocalPlayer == nil or not EntityIsAlive(LocalPlayer) then return end

    local LocalPlayerWpn = EntityGetPlayerWeapon(LocalPlayer)
    local LocalPlayerWpnClassname = EntityGetClassName(LocalPlayerWpn)

    for i=0, #Exceptions do
        if LocalPlayerWpnClassname == Exceptions[i] then return end
    end

    local LocalPlayerWpnIdx = BitBand(65535, EntityGetProp(LocalPlayerWpn, "m_iItemDefinitionIndex"))
    ActiveKey = WeaponHelpers.GetWeaponKey(LocalPlayerWpnIdx)

    if ActiveKey ~= CachedKey then
        UISet(Ctrl.CurrentWeapon, ActiveKey)
        CachedKey = ActiveKey
    end

    if not UIGet(WeaponInfo[ActiveKey].Enabled) then
        ActiveKey = "Global"
    end

    UpdateSettings(ActiveKey)        
end

local function OnPaint()
    local LocalPlayer = EntityGetLocalPlayer()

    if LocalPlayer == nil or not EntityIsAlive(LocalPlayer) then return end
    if ActiveKey == nil then return end

    local Doubletapping = UIGet(DoubletapRef[1]) and UIGet(DoubletapRef[2]) and UIGet(WeaponInfo[ActiveKey].Enabled)
    local DamageOverride = UIGet(Ctrl.DamageKey) and UIGet(WeaponInfo[ActiveKey].Enabled)
    local NoScoping = UIGet(Reference.AutoScope)

    local X, Y = ClientScreenSize()
    local XC, YC = X/2, Y/2

    local R, G, B, A = UIGet(Ctrl.MasterColor)
    local YOffset = 13

    if NoScoping == false then
        RendererText(XC, YC + YOffset, R, G, B, A, "cb", 400, "NOSCOPE")
        YOffset = YOffset + 11
    end

    -- if DamageOverride then
    --     RendererText(XC, YC + YOffset, R, G, B, A, "cb", 400, "DMG " .. UIGet(Reference.Damage))
    --     YOffset = YOffset + 11
    -- end
end
--#endregion
--#region Initialize
local function SetupWeaponGroup(name, ...)
    WeaponGroups[name] = WeaponGroups[name] or {}

    for _, WpnIdx in pairs({...}) do
        TableInsert(WeaponGroups[name], WpnIdx)
    end
end

local function SetupWeaponGroups()
    SetupWeaponGroup("Global")
    SetupWeaponGroup("Auto", 11, 38)
    SetupWeaponGroup("AWP", 9)
    SetupWeaponGroup("Scout", 40)
    SetupWeaponGroup("Deagle", 1)
    SetupWeaponGroup("Revolver", 64)
    SetupWeaponGroup("Taser", 31)
    SetupWeaponGroup("Pistol", 2, 3, 4, 30, 32, 36, 61, 63)
    SetupWeaponGroup("Rifle", 7, 8, 10, 13, 16, 39, 60)
    SetupWeaponGroup("SMG", 17, 19, 23, 24, 26, 33, 34)
    SetupWeaponGroup("Machine guns", 14, 28)
    SetupWeaponGroup("Shotgun", 25, 27, 29, 35)

    Ctrl.CurrentWeapon = UINewCombobox(Menu[1], Menu[2], "Weapon group", WeaponHelpers.GetWeaponGroups())
    GenerateWeaponControls()
end
SetupWeaponGroups()

local function Toggle()
    local State = UIGet(Ctrl.MasterSwitch)
    MenuCallback(true, true)

    local UpdateCallback = State and ClientSetEventCallback or ClientUnsetEventCallback
    UpdateCallback("setup_command", OnRunning)
    UpdateCallback("paint", OnPaint)
end

MenuCallback(Ctrl.MasterSwitch)
BindCallback(WeaponInfo, MenuCallback, "Multipoint")
BindCallback(WeaponInfo, MenuCallback, "InAir")
BindCallback(WeaponInfo, MenuCallback, "Baim")
BindCallback(WeaponInfo, MenuCallback, "Stop")
BindCallback(WeaponInfo, MenuCallback, "Doubletap")
BindCallback(WeaponInfo, MenuCallback, "Noscope")

UISetCallback(Ctrl.MasterSwitch, Toggle)
UISetCallback(Ctrl.CurrentWeapon, MenuCallback)
--#endregion