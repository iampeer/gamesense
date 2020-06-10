--#region vec3 library
local type=type;local setmetatable=setmetatable;local tostring=tostring;local a=math.pi;local b=math.min;local c=math.max;local d=math.deg;local e=math.rad;local f=math.sqrt;local g=math.sin;local h=math.cos;local i=math.atan;local j=math.acos;local k=math.fmod;local l={}l.__index=l;function Vector3(m,n,o)if type(m)~="number"then m=0.0 end;if type(n)~="number"then n=0.0 end;if type(o)~="number"then o=0.0 end;m=m or 0.0;n=n or 0.0;o=o or 0.0;return setmetatable({x=m,y=n,z=o},l)end;function l.__eq(p,q)return p.x==q.x and p.y==q.y and p.z==q.z end;function l.__unm(p)return Vector3(-p.x,-p.y,-p.z)end;function l.__add(p,q)local r=type(p)local s=type(q)if r=="table"and s=="table"then return Vector3(p.x+q.x,p.y+q.y,p.z+q.z)elseif r=="table"and s=="number"then return Vector3(p.x+q,p.y+q,p.z+q)elseif r=="number"and s=="table"then return Vector3(p+q.x,p+q.y,p+q.z)end end;function l.__sub(p,q)local r=type(p)local s=type(q)if r=="table"and s=="table"then return Vector3(p.x-q.x,p.y-q.y,p.z-q.z)elseif r=="table"and s=="number"then return Vector3(p.x-q,p.y-q,p.z-q)elseif r=="number"and s=="table"then return Vector3(p-q.x,p-q.y,p-q.z)end end;function l.__mul(p,q)local r=type(p)local s=type(q)if r=="table"and s=="table"then return Vector3(p.x*q.x,p.y*q.y,p.z*q.z)elseif r=="table"and s=="number"then return Vector3(p.x*q,p.y*q,p.z*q)elseif r=="number"and s=="table"then return Vector3(p*q.x,p*q.y,p*q.z)end end;function l.__div(p,q)local r=type(p)local s=type(q)if r=="table"and s=="table"then return Vector3(p.x/q.x,p.y/q.y,p.z/q.z)elseif r=="table"and s=="number"then return Vector3(p.x/q,p.y/q,p.z/q)elseif r=="number"and s=="table"then return Vector3(p/q.x,p/q.y,p/q.z)end end;function l.__tostring(p)return"( "..p.x..", "..p.y..", "..p.z.." )"end;function l:clear()self.x=0.0;self.y=0.0;self.z=0.0 end;function l:unpack()return self.x,self.y,self.z end;function l:length_2d_sqr()return self.x*self.x+self.y*self.y end;function l:length_sqr()return self.x*self.x+self.y*self.y+self.z*self.z end;function l:length_2d()return f(self:length_2d_sqr())end;function l:length()return f(self:length_sqr())end;function l:dot(t)return self.x*t.x+self.y*t.y+self.z*t.z end;function l:cross(t)return Vector3(self.y*t.z-self.z*t.y,self.z*t.x-self.x*t.z,self.x*t.y-self.y*t.x)end;function l:dist_to(t)return(t-self):length()end;function l:is_zero(u)u=u or 0.001;if self.x<u and self.x>-u and self.y<u and self.y>-u and self.z<u and self.z>-u then return true end;return false end;function l:normalize()local v=self:length()if v<=0.0 then return 0.0 end;self.x=self.x/v;self.y=self.y/v;self.z=self.z/v;return v end;function l:normalize_no_len()local v=self:length()if v<=0.0 then return end;self.x=self.x/v;self.y=self.y/v;self.z=self.z/v end;function l:normalized()local v=self:length()if v<=0.0 then return Vector3()end;return Vector3(self.x/v,self.y/v,self.z/v)end;function clamp(w,x,y)if w<x then return x elseif w>y then return y end;return w end;function normalize_angle(z)local A;local B;B=tostring(z)if B=="nan"or B=="inf"then return 0.0 end;if z>=-180.0 and z<=180.0 then return z end;A=k(k(z+360.0,360.0),360.0)if A>180.0 then A=A-360.0 end;return A end;function vector_to_angle(C)local v;local D;local E;v=C:length()if v>0.0 then D=d(i(-C.z,v))E=d(i(C.y,C.x))else if C.x>0.0 then D=270.0 else D=90.0 end;E=0.0 end;return Vector3(D,E,0.0)end;function angle_forward(z)local F=g(e(z.x))local G=h(e(z.x))local H=g(e(z.y))local I=h(e(z.y))return Vector3(G*I,G*H,-F)end;function angle_right(z)local F=g(e(z.x))local G=h(e(z.x))local H=g(e(z.y))local I=h(e(z.y))local J=g(e(z.z))local K=h(e(z.z))return Vector3(-1.0*J*F*I+-1.0*K*-H,-1.0*J*F*H+-1.0*K*I,-1.0*J*G)end;function angle_up(z)local F=g(e(z.x))local G=h(e(z.x))local H=g(e(z.y))local I=h(e(z.y))local J=g(e(z.z))local K=h(e(z.z))return Vector3(K*F*I+-J*-H,K*F*H+-J*I,K*G)end;function get_FOV(L,M,N)local O;local P;local Q;local R;P=angle_forward(L)Q=(N-M):normalized()R=j(P:dot(Q)/Q:length())return c(0.0,d(R))end

--#endregion

--#region vars & consts
local cached_values = {}
local active = false

--#endregion

--#region controls & references
local enabled = ui.new_checkbox("misc", "Miscellaneous", "Shanked? No")
local distance = ui.new_slider("misc", "Miscellaneous", "Toggle distance", 0, 50, 16, true, "f")
local draw_indicator = ui.new_checkbox("misc", "Miscellaneous", "Draw indicator on crosshair")
local indicator_color = ui.new_color_picker("misc", "Miscellaneous", "\n", 230, 230, 230, 255)
local indicator_height = ui.new_slider("misc", "Miscellaneous", "Indicator height", -220, 220, 60, true, "px")
local custom_speed = ui.new_checkbox("misc", "Miscellaneous", "Depend toggling on entity speed")
local speed = ui.new_slider("misc", "Miscellaneous", "Toggle speed", 0, 300, 200, true, string.format("%s", "u / s"))
local debug = ui.new_checkbox("misc", "Miscellaneous", "Debug")

local pitch = ui.reference("aa", "Anti-aimbot angles", "Pitch")
local yaw = { ui.reference("aa", "Anti-aimbot angles", "Yaw") }
local lbyt = ui.reference("aa", "Anti-aimbot angles", "Lower body yaw target")
local limit = ui.reference("aa", "Anti-aimbot angles", "Fake yaw limit")
local double_tap = { ui.reference("rage", "Other", "Double tap") }
local on_shot = { ui.reference("aa", "Other", "On shot anti-aim") }

--#endregion

--#region visibility
local function update_visibility()
    local script_state = ui.get(enabled)
    local speed_state = ui.get(custom_speed)
    local indicator_state = ui.get(draw_indicator)

    ui.set_visible(distance, script_state)
    ui.set_visible(draw_indicator, script_state)
    ui.set_visible(indicator_color, script_state and indicator_state)
    ui.set_visible(indicator_height, script_state and indicator_state)
    ui.set_visible(custom_speed, script_state)
    ui.set_visible(speed, script_state and speed_state)
    ui.set_visible(debug, script_state)
end

update_visibility()
ui.set_callback(custom_speed, update_visibility)
ui.set_callback(draw_indicator, update_visibility)

--#endregion

--#region helpers
local function vec_3(_x, _y, _z) 
	return { x = _x or 0, y = _y or 0, z = _z or 0 } 
end

--#endregion

--#region functionality
---credits to duk (https://gamesense.pub/forums/profile.php?id=510)
---thread url: https://gamesense.pub/forums/viewtopic.php?id=11453
local function get_nearest_dist()
    local nearest_dist

    local me = Vector3(entity.get_prop(entity.get_local_player(), "m_vecOrigin"))
    local enemy = nil

    for _, player in ipairs(entity.get_players(true)) do
        enemy = player

        local target = Vector3(entity.get_prop(player, "m_vecOrigin"))
        local dist = me:dist_to(target)
        if (nearest_dist == nil or dist < nearest_dist) then
            nearest_dist = dist
        end
    end

    if (nearest_dist ~= nil) then
        -- Source SDK: #define METERS_PER_INCH (0.0254f)
        local meters = nearest_dist * 0.0254
        -- Convert to feet
        local feet = meters * 3.281
        
        return feet, enemy
    end
end

--#endregion

--#region events
local function on_run_command(c)
    if not ui.get(enabled) then
        return
    end

    local nearest_dist, nearest_entity = get_nearest_dist()

    if not nearest_entity or not nearest_dist then
        if ui.get(debug) then
            client.log("[SHANKED?] No entities found.")
        end
        return
    end

    local exploit_active = ui.get(double_tap[1]) and ui.get(double_tap[2]) or ui.get(on_shot[1]) and ui.get(on_shot[2])

    local player_weapon = entity.get_player_weapon(nearest_entity)
    local idx = bit.band(65535, entity.get_prop(player_weapon, "m_iItemDefinitionIndex"))

    local enemy_velocity_prop = vec_3(entity.get_prop(nearest_entity, "m_vecVelocity"))
    local nearest_velocity = math.sqrt(enemy_velocity_prop.x^2+  enemy_velocity_prop.y^2)

    if (idx == 42) or (idx >= 500 and idx <= 525) then
        if ui.get(debug) then
            client.log(string.format("[SHANKED?] Targeted entity (%s) has knife out.", entity.get_player_name(nearest_entity)))
        end
    
        if ui.get(custom_speed) then
            if nearest_velocity <= ui.get(speed) then
                if ui.get(debug) then
                    client.log(string.format("[SHANKED?] Targeted entity (%s) their speed is under %s, speed: %s.", entity.get_player_name(nearest_entity), ui.get(speed), math.floor(nearest_velocity + 0.5)))
                end
                
                -- exit when custom speed is used and the target entity has a speed below the set speed
                return
            end
        end

        if nearest_dist <= ui.get(distance) then
            if ui.get(debug) then
                client.color_log(30, 220, 30, string.format("[SHANKED?] Targeted entity (%s) their distance to local player is below set distance %s, distance: %s.", entity.get_player_name(nearest_entity), ui.get(distance), math.floor(nearest_dist + 0.5)))
            end

            if active == false then
                cached_values.pitch = ui.get(pitch)
                cached_values.yaw = ui.get(yaw[1])
                cached_values.yaw_angle = ui.get(yaw[2])
                cached_values.lbyt = ui.get(lbyt)
                cached_values.limit = ui.get(limit)

                if ui.get(debug) then
                    client.log(string.format("[SHANKED?] Cached anti-aim values."))
                end  
            end

            active = true
            
            ui.set(pitch, "Off")
            ui.set(yaw[1], "180")
            ui.set(yaw[2], 180)
            ui.set(lbyt, not exploit_active and "Opposite" or "Eye yaw")
            ui.set(limit, 60)
        else
            if ui.get(debug) then
                client.color_log(220, 30, 30, string.format("[SHANKED?] Targeted entity (%s) their distance to local player is above set distance %s, distance: %s.", entity.get_player_name(nearest_entity), ui.get(distance), math.floor(nearest_dist + 0.5)))
            end

            if cached_values.pitch ~= nil then
                ui.set(pitch, cached_values.pitch)
                ui.set(yaw[1], cached_values.yaw)
                ui.set(yaw[2], cached_values.yaw_angle)
                ui.set(lbyt, cached_values.lbyt)
                ui.set(limit, cached_values.limit)

                if ui.get(debug) then
                    client.log("[SHANKED?] Anti-aim values reset.")
                end
            end

            active = false
        end
    else
        -- weapon is not a knife
    end

    if ui.get(debug) then
        client.log(string.format("[SHANKED?] Nearest entity (%s) is %sft away and has a speed of %su/s", entity.get_player_name(nearest_entity), math.floor(nearest_dist + 0.5), math.floor(nearest_velocity + 0.5)))
    end
end

local function on_paint()
    if not ui.get(enabled) then
        return
    end

    local nearest_dist, nearest_entity = get_nearest_dist()

    if not nearest_entity or not nearest_dist then
        return
    end

    local sx, sy = client.screen_size()
    local cx, cy = sx / 2, sy / 2
    local r, g, b, a = ui.get(indicator_color)

    if active and ui.get(draw_indicator) then 
        renderer.text(cx, cy + ui.get(indicator_height), r, g, b, a, "cb", 0, "shank? no!")
    end
end
--#endregion

--#region init
---credits to NmChris (https://gamesense.pub/forums/profile.php?id=747)
local function script_toggled()
    local state = ui.get(enabled)

    update_visibility()

    local update_callback = state and client.set_event_callback or client.unset_event_callback
    update_callback("run_command", on_run_command)
    update_callback("paint", on_paint)
end

script_toggled()
ui.set_callback(enabled, script_toggled)

--#endregion