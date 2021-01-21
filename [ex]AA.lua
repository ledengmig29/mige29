require "bit" --update 2021/1/13
local vector = require 'vector'
local ffi = require("ffi")
local js = panorama['open']()
local MyPersonaAPI, LobbyAPI, PartyListAPI, FriendsListAPI, GameStateAPI = js['MyPersonaAPI'], js['LobbyAPI'], js['PartyListAPI'], js['FriendsListAPI'], js['GameStateAPI']


local client_set_event_callback, ui_get, ui_set, ui_new_checkbox, ui_new_combobox, ui_new_slider, ui_reference, ui_set_visible = client.set_event_callback, ui.get, ui.set, ui.new_checkbox, ui.new_combobox, ui.new_slider, ui.reference, ui.set_visible

local notify = (function()
    local notify = {callback_registered = false, maximum_count = 7, data = {}, svg_texture = [[<svg id="Capa_1" enable-background="new 0 0 512 512" height="512" viewBox="0 0 512 512" width="512" xmlns="http://www.w3.org/2000/svg"><g><g><path d="m216.188 82.318h48.768v37.149h-48.768z" fill="#ffcbbe"/></g><g><path d="m250.992 82.318h13.964v37.149h-13.964z" fill="#fdad9d"/></g><g><ellipse cx="240.572" cy="47.717" fill="#ffcbbe" rx="41.682" ry="49.166" transform="matrix(.89 -.456 .456 .89 4.732 115.032)"/></g><g><path d="m277.661 28.697c-10.828-21.115-32.546-32.231-51.522-27.689 10.933 4.421 20.864 13.29 27.138 25.524 12.39 24.162 5.829 52.265-14.654 62.769-2.583 1.325-5.264 2.304-8.003 2.96 10.661 4.31 22.274 4.391 32.387-.795 20.483-10.504 27.044-38.607 14.654-62.769z" fill="#fdad9d"/></g><g><path d="m296.072 296.122h-111.001v-144.174c0-22.184 17.984-40.168 40.168-40.168h30.666c22.184 0 40.168 17.984 40.168 40.168v144.174z" fill="#95d6a4"/></g><g><path d="m256.097 111.78h-24.384c22.077 0 39.975 17.897 39.975 39.975v144.367h24.384v-144.367c0-22.077-17.897-39.975-39.975-39.975z" fill="#78c2a4"/></g><g><path d="m225.476 41.375c0-8.811 7.143-15.954 15.954-15.954h34.401c-13.036-21.859-38.163-31.469-57.694-21.453-19.846 10.177-26.623 36.875-15.756 60.503 12.755-.001 23.095-10.341 23.095-23.096z" fill="#756e78"/></g><g><path d="m252.677 25.421h23.155c-11.31-18.964-31.718-28.699-49.679-24.408 10.591 4.287 20.23 12.757 26.524 24.408z" fill="#665e66"/></g><g><path d="m444.759 453.15-28.194-9.144c-3.04-.986-5.099-3.818-5.099-7.014v-4.69l-2.986-8.22h-61.669l-2.986 8.22v34.22c0 8.628 6.994 15.622 15.622 15.622h81.993c5.94 0 10.755-4.815 10.755-10.755v-8.008c.001-4.662-3.002-8.793-7.436-10.231z" fill="#aa7a63"/></g><g><path d="m444.759 453.15-28.194-9.144c-3.04-.986-5.099-3.818-5.099-7.014v-4.69l-2.986-8.22h-25.91v12.911c0 3.196 2.059 6.028 5.099 7.014l28.194 9.144c4.434 1.438 7.437 5.569 7.437 10.23v8.008c0 5.94-4.815 10.755-10.755 10.755h28.896c5.94 0 10.755-4.815 10.755-10.755v-8.008c0-4.662-3.003-8.793-7.437-10.231z" fill="#986b54"/></g><g><path d="m343.827 344.798v87.505h67.64v-123.053c0-20.65-16.74-37.39-37.39-37.39h-189.006v33.212c0 19.014 15.414 34.428 34.428 34.428h119.03c2.926 0 5.298 2.372 5.298 5.298z" fill="#5766cb"/></g><g><path d="m382.571 309.25v123.052h28.896v-123.052c0-20.65-16.74-37.39-37.39-37.39h-28.896c20.65 0 37.39 16.74 37.39 37.39z" fill="#3d4fc3"/></g><g><g><path d="m437.268 512h-108.548c-8.244 0-14.928-6.684-14.928-14.928v-107.221c0-11.247-9.15-20.399-20.398-20.399h-123.543c-8.244 0-14.928-6.684-14.928-14.928v-150.17h-22.748c-8.244 0-14.928-6.684-14.928-14.928s6.684-14.928 14.928-14.928h37.676c8.244 0 14.928 6.684 14.928 14.928v150.17h108.616c27.71 0 50.254 22.545 50.254 50.255v92.293h93.619c8.244 0 14.928 6.684 14.928 14.928s-6.684 14.928-14.928 14.928z" fill="#756e78"/></g></g><g><g><path d="m437.268 482.144h-15.115c8.244 0 14.928 6.684 14.928 14.928s-6.683 14.928-14.928 14.928h15.115c8.244 0 14.928-6.684 14.928-14.928s-6.684-14.928-14.928-14.928z" fill="#665e66"/></g><g><path d="m328.534 389.851v83.296c0 4.969 4.028 8.997 8.997 8.997h6.118v-92.293c0-27.755-22.5-50.255-50.255-50.255h-15.114c27.71 0 50.254 22.545 50.254 50.255z" fill="#665e66"/></g><g><path d="m169.664 189.426v150.17h15.115v-150.17c0-8.244-6.684-14.928-14.928-14.928h-15.115c8.245 0 14.928 6.684 14.928 14.928z" fill="#665e66"/></g></g><g><g><path d="m171.702 511.498c-61.701 0-111.898-50.197-111.898-111.898s50.197-111.898 111.898-111.898 111.898 50.197 111.898 111.898-50.197 111.898-111.898 111.898zm0-193.94c-45.238 0-82.042 36.804-82.042 82.042s36.804 82.042 82.042 82.042 82.042-36.804 82.042-82.042-36.804-82.042-82.042-82.042z" fill="#756e78"/></g></g><g><g><path d="m243.485 313.833c16.3 19.444 26.131 44.485 26.131 71.783 0 61.701-50.197 111.898-111.898 111.898-27.298 0-52.339-9.831-71.783-26.131 20.543 24.504 51.364 40.115 85.767 40.115 61.701 0 111.898-50.197 111.898-111.898 0-34.403-15.61-65.225-40.115-85.767z" fill="#665e66"/></g></g><g><path d="m384.583 259.81 13.927 12.767c8.319 7.626 13.447 18.117 14.353 29.366l.509 6.316c.283 3.513-3.591 5.82-6.545 3.898l-45.845-29.834z" fill="#ffcbbe"/></g><g><path d="m413.372 308.259-.509-6.316c-.906-11.249-6.034-21.74-14.353-29.366l-13.927-12.767-7.744 7.387 5.869 5.38c8.319 7.626 13.447 18.117 14.353 29.366l.328 4.072 9.438 6.142c2.954 1.921 6.828-.386 6.545-3.898z" fill="#fdad9d"/></g><g><g><path d="m366.869 290.965c-1.448 1.448-3.783 1.589-5.341.26-8.038-6.857-18.146-10.594-28.827-10.594h-69.416c-31.072 0-56.26-25.188-56.26-56.26v-63.312c0-12.367 10.025-22.392 22.392-22.392 12.367 0 22.392 10.025 22.392 22.392v63.312c0 6.338 5.138 11.476 11.476 11.476h69.415c22.462 0 43.657 8.238 60.136 23.284 1.672 1.526 1.716 4.151.115 5.752z" fill="#95d6a4"/></g></g><g><path d="m392.836 259.13c-16.479-15.047-37.674-23.284-60.136-23.284h-69.416c-6.338 0-11.476-5.138-11.476-11.476v-63.312c0-12.367-10.025-22.392-22.392-22.392-3.429 0-6.676.773-9.581 2.151 5.315 4.094 8.743 10.518 8.743 17.746v74.508c0 6.338 5.138 11.476 11.476 11.476h69.416c22.462 0 43.657 8.238 60.136 23.284 1.672 1.526 1.716 4.151.115 5.752l-13.663 13.663c1.907 1.181 3.739 2.503 5.469 3.979 1.558 1.329 3.893 1.188 5.341-.26l26.082-26.082c1.602-1.602 1.558-4.226-.114-5.753z" fill="#78c2a4"/></g></g></svg>
]]}
    local svg_size = { w = 20, h = 20}
    local svg = renderer.load_svg(notify.svg_texture, svg_size.w, svg_size.h)
    function notify:register_callback()
        if self.callback_registered then return end
        client.set_event_callback('paint_ui', function()
            local screen = {client.screen_size()}
            local color = {15, 15, 15}
            local d = 5;
            local data = self.data;
            for f = #data, 1, -1 do
                data[f].time = data[f].time - globals.frametime()
                local alpha, h = 255, 0;
                local _data = data[f]
                if _data.time < 0 then
                    table.remove(data, f)
                else
                    local time_diff = _data.def_time - _data.time;
                    local time_diff = time_diff > 1 and 1 or time_diff;
                    if _data.time < 0.5 or time_diff < 0.5 then
                        h = (time_diff < 1 and time_diff or _data.time) / 0.5;
                        alpha = h * 255;
                        if h < 0.2 then
                            d = d + 15 * (1.0 - h / 0.2)
                        end
                    end
                    local text_data = {renderer.measure_text("dc", _data.draw)}
                    local screen_data = {
                        screen[1] / 2 - text_data[1] / 2 + 3, screen[2] - screen[2] / 100 * 17.4 + d
                    }
                    renderer.rectangle(screen_data[1] - 30, screen_data[2] - 22, text_data[1] + 60, 2, 83, 126, 242, alpha)
                    renderer.rectangle(screen_data[1] - 29, screen_data[2] - 20, text_data[1] + 58, 29, color[1], color[2],color[3], alpha <= 135 and alpha or 135)
                    renderer.line(screen_data[1] - 30, screen_data[2] - 22, screen_data[1] - 30, screen_data[2] - 20 + 30, 83, 126, 242, alpha <= 50 and alpha or 50)
                    renderer.line(screen_data[1] - 30 + text_data[1] + 60, screen_data[2] - 22, screen_data[1] - 30 + text_data[1] + 60, screen_data[2] - 20 + 30, 83, 126, 242, alpha <= 50 and alpha or 50)
                    renderer.line(screen_data[1] - 30, screen_data[2] - 20 + 30, screen_data[1] - 30 + text_data[1] + 60, screen_data[2] - 20 + 30, 83, 126, 242, alpha <= 50 and alpha or 50)
                    renderer.text(screen_data[1] + text_data[1] / 2 + 10, screen_data[2] - 5, 255, 255, 255, alpha, 'dc', nil, _data.draw)
                    renderer.texture(svg, screen_data[1] - svg_size.w/2 - 5, screen_data[2] - svg_size.h/2 - 5, svg_size.w, svg_size.h, 255, 255, 255, alpha)
                    d = d - 50
                end
            end
            self.callback_registered = true
        end)
    end
    function notify:paint(time, text)
        local timer = tonumber(time) + 1;
        for f = self.maximum_count, 2, -1 do
            self.data[f] = self.data[f - 1]
        end
        self.data[1] = {time = timer, def_time = timer, draw = text}
        self:register_callback()
    end
    return notify
end)()

ffi.cdef[[
  typedef struct
  {
    int64_t pad_0;
    union {
      int xuid;
      struct {
        int xuidlow;
        int xuidhigh;
      };
    };
    char name[128];
    int userid;
    char guid[33];
    unsigned int friendsid;
    char friendsname[128];
    bool fakeplayer;
    bool ishltv;
    unsigned int customfiles[4];
    unsigned char filesdownloaded;
  } S_playerInfo_t;

  typedef bool(__thiscall* fnGetPlayerInfo)(void*, int, S_playerInfo_t*);

  typedef void(__thiscall* clientcmdun)(void*, const char* , bool);
  
  typedef bool(__thiscall* is_in_game)(void*);
  
  typedef bool(__thiscall* is_connected)(void*, bool);
  
  typedef int(__thiscall* get_local_player_ffi)(void*);
]]

local pEngineClient = ffi.cast(ffi.typeof("void***"), client.create_interface("engine.dll", "VEngineClient014"))

-- c++ function predefs

--12
local fnGetPlayerInfo = ffi.cast("fnGetPlayerInfo", pEngineClient[0][8])
local clientcmdun = ffi.cast("clientcmdun", pEngineClient[0][114]) 
local is_in_game = ffi.cast("is_in_game", pEngineClient[0][26])
--local is_connected = ffi.cast("is_connected", pEngineClient[0][27])
--local get_local_player_ffi = ffi.cast("get_local_player_ffi", pEngineClient[0][12])

-- c++ function predefs
local pinfo_struct = ffi.new("S_playerInfo_t[1]")
local lp_entidx = entity.get_local_player()
local steamid = nil
local pritsteamid = nil
if lp_entidx then
  fnGetPlayerInfo(pEngineClient, lp_entidx, pinfo_struct)
  steamid = pinfo_struct[0].xuid
  pritsteamid = ffi.string(pinfo_struct[0].guid)
  end
local local_id = steamid
local return_name_string = entity.get_player_name(entity.get_local_player())
local is_valid_user = 0
-- c++ function predefs

local value3 = 255
local state3 = false

 function clamp(v, min, max)
	return math.max(math.min(v, max), min)
end

client.set_event_callback("run_command", function()
	local increment = (1 * globals.frametime()) * 255

	if (value3 ~= 0 and not state3) then
		value3 =  clamp(value3 - increment, 0, 255)
	end

 	if (value3 ~= 255 and state3) then
		value3 = clamp(value3 + increment, 0, 255)
	end

 	if (value3 == 0) then
		state3 = true
	end

 	if (value3 == 255) then
		state3 = false
	end

end)

client.exec("toggleconsole")

local function contains(table, val)
	for i=1, #table do
		if table[i] == val then
			return true
		end
	end

 	return false
end

local choked = 0

    notify:paint(5, "[TEST.tech] attempting to connect...")
    client.delay_call(1, function()
            notify:paint(4, "[TEST.tech] connection settuped, logged in as: ")
                client.delay_call(2, function()
                    notify:paint(4, "[TEST.tech] anti-aim lua has been successfully installed!")
        end)
    end)



      
client.delay_call(0.3, function()
client.color_log(255, 124, 60, "[TEST.tech] downloaded 25%")
client.delay_call(0.3, function()
client.color_log(255, 34, 123, "[TEST.tech] downloaded 49%")
client.delay_call(0.3, function()
client.color_log(255, 32, 245, "[TEST.tech] downloaded 84%")
client.delay_call(0.3, function()
client.color_log(250, 43, 33, "[TEST.tech] downloaded 100%")
client.delay_call(0.3, function()
client.color_log(255, 60, 140, "[TEST.tech] anti-aim lua installed")
                        end)
                    end)
                end)
            end)
        end)





local enable_lua = ui.new_checkbox("AA", "Anti-aimbot angles", "enable TEST.tech - alpha")
local lua_tab = ui.new_combobox("AA", "Anti-aimbot angles", "[TEST] Current tab", "Anti-aim", "Indication", "Misc")


local change_aa_on_key = ui.new_hotkey("AA", "Anti-aimbot angles", "[TEST] Dodge anti-aim mode")
local aa_mode = ui.new_combobox("AA", "Anti-aimbot angles", "[TEST] Yaw mode", {"Static", "Jitter"})
local jitter_aa = ui.new_checkbox("AA", "Anti-aimbot angles", "[TEST] Alternative jitter mode")
local jitter_dormant = ui.new_checkbox("AA", "Anti-aimbot angles", "[TEST] Jitter on dormant")
local legit_aa = ui.new_checkbox("AA", "Anti-aimbot angles", "[TEST] Legit anti-aim")
local legit_aa_key = ui.new_hotkey("AA", "Anti-aimbot angles", "[TEST] Legit AA Key", true)
local legit_aa_mode = ui.new_combobox("AA", "Anti-aimbot angles", "[TEST] Legit anti-aim mode", {"On key", "On use (e button)", "On peek"})

local vars = {
    enable = ui.new_checkbox('AA', 'anti-aimbot angles', '[TEST] Manual anti-aim'),
	key_left = ui.new_hotkey("AA", "Anti-aimbot angles", "[TEST] Manual Left <", false),
	key_right = ui.new_hotkey("AA", "Anti-aimbot angles", "[TEST] Manual Right >", false),
	key_back = ui.new_hotkey("AA", "Anti-aimbot angles", "[TEST] Manual Back V", false),
}

local auto_invert = ui.new_checkbox("AA", "Anti-aimbot angles", "[TEST] Automatic inverter")
local anti_brute = ui.new_multiselect("AA", "Anti-aimbot angles", "[TEST] Anti-bruteforce", {"On hit", "On miss", "On shot"})

local indicator_style = ui.new_combobox("AA", "Anti-aimbot angles", "[TEST] Anti-aim indication style", {"Off", "Circle", "Arrows", "Circle + Arrows", "Line", "Arrows + Line"})

local byaw_label = ui.new_label("AA", "Anti-aimbot angles", "[TEST] Circle color")
local byaw_clr = ui.new_color_picker("AA", "Anti-aimbot angles", "clr1", 89, 119, 239, 255, true)
local byaw_based = ui.new_checkbox('AA', 'anti-aimbot angles', '[TEST] Body yaw based')

local side_label = ui.new_label("AA", "Anti-aimbot angles", "[TEST] Arrow indicator color")
local side_clr = ui.new_color_picker("AA", "Anti-aimbot angles", "clr", 89, 119, 239, 255, true)

local line_label1 = ui.new_label("AA", "Anti-aimbot angles", "[TEST] First gradient color")
local line_clr1 = ui.new_color_picker("AA", "Anti-aimbot angles", "Line clr1", 255, 0, 127, 0, true)

local line_label2 = ui.new_label("AA", "Anti-aimbot angles", "[TEST] Second gradient color")
local line_clr2 = ui.new_color_picker("AA", "Anti-aimbot angles", "Line clr2", 255, 0, 127, 255, true)

local aa_legs = ui.new_checkbox("AA", "anti-aimbot angles", "[TEST] Better leg movement")
local aa_enabled = ui.new_checkbox('AA', 'anti-aimbot angles', '[TEST] Anti-aim indication')

local edge_key = ui.new_hotkey("AA", "Anti-aimbot angles", "[TEST] Edge yaw anti-aim mode", false)

local misc_onpeek = ui.new_checkbox("AA", "Anti-aimbot angles", "[TEST] Alternative peek fake-lag")

 ---- stuff for indicators --------------
local slider_limit = ui.reference('aa', 'fake lag', 'limit')

 -- Keybinds
local hotkey_force_safe_point = ui.reference('rage', 'aimbot', 'force safe point')
local hotkey_force_body_aim = ui.reference('rage', 'other', 'force body aim')
local hotkey_duck_peek_assist = ui.reference('rage', 'other', 'duck peek assist')
local checkbox_double_tap, hotkey_double_tap = ui.reference('rage', 'other', 'double tap')
local checkbox_on_shot, hotkey_on_shot = ui.reference('aa', 'other', 'On shot anti-aim')
local hotkey_fake_peek = ui.reference('aa', 'other', 'Fake peek')
local checkbox_force_third_person, hotkey_force_third_person = ui.reference('visuals', 'effects', 'force third person (alive)')

---- stuff for indicators --------------

local indicator = {
    enable = ui.new_checkbox("AA", "Anti-Aimbot angles", "[TEST] Crosshair Indicators"),
    font = ui.new_combobox("AA", "Anti-aimbot angles", "[TEST] Indicator font", {"Default", "Default centered", "Big", "Big centered", "Bold", "Bold centered"})
}

local watermark111 = ui.new_checkbox("AA", "Anti-Aimbot angles", '[TEST] Watermark')
local watermark111_clr = ui.new_color_picker("AA", "Anti-Aimbot angles", '[TEST] \n Watermark color', 255, 0, 255, 255)

 local screen_size_x, screen_size_y = 0

 --local ui_get = ui.get

 local fs, fs_key, fs_cond = ui.reference("AA", "Anti-aimbot angles", "Freestanding")
local pitch = ui.reference("AA", "Anti-aimbot angles", "Pitch")
local yaw, yaw_add = ui.reference("AA", "Anti-aimbot angles", "Yaw")
local jitter, jitter2, jitter3 = ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")
local body, body_add = ui.reference("AA", "Anti-aimbot angles", "Body yaw")
local yaw_base = ui.reference("AA", "Anti-aimbot angles", "Yaw base")
local lby = ui.reference("AA", "Anti-aimbot angles", "Lower body yaw target")
local dt, dt2, dt3 = ui.reference("Rage", "Other", "Double tap")
local on_shot, on_shot2 = ui.reference("AA", "Other", "On shot anti-aim")
local fp, fp2 = ui.reference("AA", "Other", "Fake peek")
local fd = ui.reference("RAGE", "Other", "Duck peek assist")
local freestand_byaw = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw")
local yaw_limit = ui.reference("AA", "Anti-aimbot angles", "Fake yaw limit")
local edge_yaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw")
local fl_amount = ui_reference("AA", "fake lag", "amount")

 local is_left, is_right, is_back = false
local left_pressed, right_pressed, back_pressed = false
local left_clicked, right_clicked, back_clicked = false
local left_state, right_state, back_state = 0

local function get_direction()
	if not entity.is_alive(entity.get_local_player()) then return end

 	if ui_get(vars.key_left) then
		left_pressed = true
		left_clicked = false
	elseif not ui_get(vars.key_left) and left_pressed then
		left_pressed =  false
		left_clicked = true
	else
		left_pressed =  false
		left_clicked =  false
	end

	if ui_get(vars.key_right) then
		right_pressed = true
		right_clicked = false
	elseif not ui_get(vars.key_right) and right_pressed then
		right_pressed =  false
		right_clicked = true
	else
		right_pressed  =  false
		right_clicked =  false
	end

	if ui_get(vars.key_back) then
		back_pressed = true
		back_clicked = false
	elseif not ui_get(vars.key_back) and back_pressed then
		back_pressed =  false
		back_clicked = true
	else
		back_pressed =  false
		back_clicked =  false
	end
	if back_clicked then
		if back_state == 3 then
			back_state = 0
			is_right = false
			is_left = false
			is_back = true
		else
			back_state = 3
			left_state = 0
			right_state = 0
			is_back = true
			is_right, is_left = false
		end
	elseif left_clicked then
		if left_state == 1 then
			left_state = 0
			is_left = false
			is_back = true
		else
			left_state = 1
			right_state = 0
			back_state = 0
			is_left = true
			is_right, is_back = false
		end
	elseif right_clicked then
		if right_state == 2 then
			right_state = 0
			is_right = false
			is_back = true
		else
			right_state = 2
			left_state = 0
			back_state = 0
			is_right = true
			is_left, is_back = false
		end
	end
end

 local function normalize_yaw(angle)
	angle = (angle % 360 + 360) % 360
	return angle > 180 and angle - 360 or angle
end

 local color_table = {
    {0, 124, 195, 13, 255},
    {0.125, 176, 205, 10, 255},
    {0.25, 213, 201, 19, 255},
    {0.375, 220, 169, 16, 255},
    {0.5, 228, 126, 10, 255},
    {0.625, 229, 104, 8, 255},
    {0.75, 235, 63, 6, 255},
    {0.875, 237, 27, 3, 255},
    {1, 255, 0, 0, 255}
}

local function get_color_by_float(float, pow)
    local float = math.min(math.max(float, 0.000001), 0.999999)
    local color_lower 
    local color_higher 
    local distance_lower = 1
    local distance_higher = 1

    for i = 1, #color_table do 
        local color = color_table[i]
        local color_float = color[1]
        if color_float == float then 
            return color[2], color[3], color[4], color[5]
        elseif color_float > float then 
            local distance = color_float - float 
            if distance < distance_higher then 
                color_higher = color 
                distance_higher = distance
            end
        elseif color_float < float then 
            local distance = float - color_float
            if distance < distance_lower then 
                color_lower = color 
                distance_lower = distance
            end
        end
    end
    distance_lower, distance_higher = distance_lower^pow, distance_higher^pow
    local distance_difference = distance_lower + distance_higher
    local red = (color_lower[2] * distance_higher + color_higher[2] * distance_lower) / distance_difference
    local green = (color_lower[3] * distance_higher + color_higher[3] * distance_lower) / distance_difference
    local blue = (color_lower[4] * distance_higher + color_higher[4] * distance_lower) / distance_difference
    local alpha = (color_lower[5] * distance_higher + color_higher[5] * distance_lower) / distance_difference

    return red, green, blue, alpha
end

local enable_legit_aa = false


local vec_3 = function(_x, _y, _z) 
	return { x = _x or 0, y = _y or 0, z = _z or 0 } 
end

local w2s = function(xd, yd)
    if (xd == 0 and yd == 0) then
        return 0
    end

    return math.deg(math.atan2(yd, xd))
end

local round = function(num, dec) 
    local mult = 10^(dec or 0)

    return math.floor(num * mult + 0.5) / mult
end

local rotate_point = function(x, y, r, s)
    return (math.cos(math.rad(r)) * s + x), (math.sin(math.rad(r)) * s + y)
end

local function ticks_to_time(ticks)
    return globals.tickinterval() * ticks
end

local get_flags = function(ent)
    local state = "stand"

    local flags = entity.get_prop(ent, "m_fFlags")
    local vel_prop = vec_3(entity.get_prop(ent, "m_vecVelocity"))
    local velocity = math.floor(math.min(10000, math.sqrt(vel_prop.x^2 + vel_prop.y^2) + 0.5))

    if bit.band(flags, 1) ~= 1 then state = "air" else
        if (entity.get_prop(ent, "m_flDuckAmount") > 0.7) then
            state = "duck"
        elseif velocity > 1 then
            if velocity <= 120 then 
                state = "slow"
            else
                state = "move"
            end
        else
            state = "stand"
        end
    end

    return {
        velocity = velocity,
        state = state
    }
end

local will_peek = function()
    local enemies = entity.get_players(true)
    if (#enemies == 0) then
        return false
    end
    
	local exp = ui.get(on_shot) and ui.get(on_shot2)

    local me = entity.get_local_player()
    local predicted = ui.get(ui.reference("aa", "Fake lag", "Limit"))

    local eye_pos = vec_3(client.eye_position())
	local vel_prop_local = vec_3(entity.get_prop(me, "m_vecVelocity"))
    local local_vel = math.sqrt(vel_prop_local.x^2+vel_prop_local.y^2)
    
    local data = get_flags(me)

    if (data.state == "duck") then
        return false
    end

    if exp then
        return false
    end

    if (data.velocity < 5 or data.state == "air") then
        return false
    end

    local pred_eye_pos = vec_3(eye_pos.x + vel_prop_local.x * ticks_to_time(predicted), eye_pos.y + vel_prop_local.y * ticks_to_time(predicted), eye_pos.z + vel_prop_local.z * ticks_to_time(predicted))

    for i = 1, #enemies do
        local player = enemies[i]

        local vel_prop = vec_3(entity.get_prop(player, "m_vecVelocity"))
        local origin = vec_3(entity.get_prop(player, "m_vecOrigin"))
        local pred_origin = vec_3(origin.x + vel_prop.x * ticks_to_time(16), origin.y + vel_prop.y * ticks_to_time(16), origin.x + vel_prop.x * ticks_to_time(16))

        entity.get_prop(player, "m_vecOrigin", pred_origin)

        local head_origin = vec_3(entity.hitbox_position(player, 0))
		local pred_head_origin = vec_3(head_origin.x + vel_prop.x * ticks_to_time(16), head_origin.y + vel_prop.y * ticks_to_time(16), head_origin.z + vel_prop.z * ticks_to_time(16))
		local trace_entity, damage = client.trace_bullet(me, pred_eye_pos.x, pred_eye_pos.y, pred_eye_pos.z, pred_head_origin.x, pred_head_origin.y, pred_head_origin.z)

		entity.get_prop(player, "m_vecOrigin", origin)

		local current_player = player
		
		if damage > 0 and entity.is_alive(current_player) then
            if player ~= current_player then 
                return false 
            end

			current_player = player
			return true
		end
	end
		
    return false
end

local freestanding_body_yaw = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw")
client.set_event_callback('setup_command', function(e)
    enable_legit_aa = ui.get(legit_aa) and 
        ((ui.get(legit_aa_mode) == "On key" and ui.get(legit_aa_key)) 
            or (ui.get(legit_aa_mode) == "On use (e button)" and client.key_state(0x45)) 
            or (ui.get(legit_aa_mode) == "On peek" and will_peek()))

    choked = e.chokedcommands

	if enable_legit_aa then
		local weaponn = entity.get_player_weapon()
		if weaponn ~= nil and entity.get_classname(weaponn) == "CC4" then
			if e.in_attack == 1 then
				e.in_attack = 0
				e.in_use = 1
			end
		else
			if e.chokedcommands == 0 then
				e.in_use = 0
			end
		end
		--ui.set(freestanding_body_yaw, true)
	end
end)

 local function get_near_target()
	local enemy_players = entity.get_players(true)
	if #enemy_players ~= 0 then
		local own_x, own_y, own_z = client.eye_position()
		local own_pitch, own_yaw = client.camera_angles()
		local closest_enemy = nil
		local closest_distance = 999999999

 		for i = 1, #enemy_players do
			local enemy = enemy_players[i]
			local enemy_x, enemy_y, enemy_z = entity.get_prop(enemy, "m_vecOrigin")

 			local x = enemy_x - own_x
			local y = enemy_y - own_y
			local z = enemy_z - own_z

 			local yaw = ((math.atan2(y, x) * 200 / math.pi))
			local pitch = -(math.atan2(z, math.sqrt(math.pow(x, 2) + math.pow(y, 2))) * 200 / math.pi)

 			local yaw_dif = math.abs(own_yaw % 360 - yaw % 360) % 360
			local pitch_dif = math.abs(own_pitch - pitch ) % 360

 			if yaw_dif > 180 then yaw_dif = 360 - yaw_dif end
			local real_dif = math.sqrt(math.pow(yaw_dif, 2) + math.pow(pitch_dif, 2))

 			if closest_distance > real_dif then
				closest_distance = real_dif
				closest_enemy = enemy
			end
		end

 		if closest_enemy ~= nil then
			return closest_enemy, closest_distance
		end
	end

 	return nil, nil
end


local do_it_once = false
local do_it_once2 = false
local do_it_once3 = false
local do_it_once4 = false
local do_it_once5 = false
local dormant = false
local reset_jitter = false
local function set_direction()
	local exp = ui.get(dt) and ui.get(dt2) or ui.get(on_shot) and ui.get(on_shot2)
	if not entity.is_alive(entity.get_local_player()) then return end

    local flags = entity.get_prop(entity.get_local_player(), "m_fFlags")
    local is_air = flags == 256
	if is_air or is_back then
		ui.set(yaw_base, "At targets")
	else
		ui.set(yaw_base, "Local view")
    end
    
    local hittable = will_peek() or is_air
    if ui.get(misc_onpeek) then
		if hittable then
			ui.set(fl_amount,"Fluctuate")--Fluctuate
		else
			ui.set(fl_amount,"Dynamic")
		end
	end	

    ui.set(jitter, ui.get(aa_mode) == "Jitter" and "Center" or "Off")
    ui.set(jitter2, ui.get(aa_mode) == "Jitter" and 5 or 0)

 	if enable_legit_aa then
		ui.set(pitch, "Off")
		ui.set(yaw_add, 180)
		if ui.get(jitter_aa) then
			ui.set(body, "Jitter")
			ui.set(body_add, 90)
			ui.set(lby, "Eye yaw")
		else
			ui.set(body, "Static")
			ui.set(lby, exp and "Eye yaw" or "Opposite")
			ui.set(body_add, 180)
		end
		ui.set(yaw_base, "Local View")
		ui.set(freestanding_body_yaw, true)
		do_it_once2 = false
	else
    
        local target = get_near_target()

 		if ui.get(jitter_aa) or (target == nil and ui.get(jitter_dormant)) then
			ui.set(body, "Jitter")
			ui.set(body_add, 90)
			ui.set(lby, "Eye yaw")
			reset_jitter = false
		else
			if not reset_jitter then
				ui.set(body, "Static")
				ui.set(body_add, 0)
				ui.set(lby, "Eye yaw")
				ui.set(yaw_add, 0)
				reset_jitter = true
			end
		end

 		if not do_it_once2 then
			ui.set(pitch, "Minimal")
			ui.set(yaw_base, "Local view")
			ui.set(lby, "Eye yaw")
			ui.set(yaw_add, 0)
			ui.set(freestanding_body_yaw, false)
			do_it_once2 = true
		end

         if ui.get(change_aa_on_key) then
            ui.set(yaw_base, "Local view")
            ui.set(yaw_add, 13)
            ui.set(body, "Jitter")
            ui.set(body_add, -31)
            ui.set(lby, "Eye yaw")
            ui.set(yaw_limit, 44)
            do_it_once3 = false
		else	
			if not do_it_once3 then
				ui.set(yaw_add, 0)
				ui.set(yaw_limit, 60)
                ui.set(body, "Static")
                ui.set(lby, "Eye yaw")
				ui.set(body_add, 180)
				do_it_once3 = true
			end
        
            if ui.get(vars.enable) then
                if is_left then
                    ui.set(yaw_add, -90)
                    do_it_once = false
                elseif is_right then
                        ui.set(yaw_add, 90)
                    do_it_once = false
                elseif is_back then
                    if not do_it_once then
                            ui.set(yaw_add, 0)
                        do_it_once = true
                    end
                end
            end
		end
	end
end

 function clamp(v, min, max)
	return math.max(math.min(v, max), min)
end

 local set_once = false

 local menu_clr = ui.reference("MISC", "Settings", "Menu color")

 local min_dmg = ui.reference("RAGE", "Aimbot", "Minimum damage")
local sf =  ui.reference("RAGE", "Aimbot", "Force safe point")
local baim =  ui.reference("RAGE", "Other", "Force body aim")

 local function player_is_on_esp(player)
    local players = entity.get_players(true)
    for _, v in pairs(players) do
        if v == player then
            return true
        end
    end
    return false
end 

 local function map(n, start, stop, new_start, new_stop)
    local value = (n - start) / (stop - start) * (new_stop - new_start) + new_start

     return new_start < new_stop and math.max(math.min(value, new_stop), new_start) or math.max(math.min(value, new_start), new_stop)
end

 -- watermark nick
local user = username 

 local frametimes = { }
local fps_prev = 0
local last_update_time = 0

 function AccumulateFps()
	local ft = globals.absoluteframetime()
	if ft > 0 then
		table.insert(frametimes, 1, ft)
	end
	local count = #frametimes
	if count == 0 then
		return 0
	end
	local i, accum = 0, 0
	while accum < 0.5 do
		i = i + 1
		accum = accum + frametimes[i]
		if i >= count then
			break
		end
	end
	accum = accum / i
	while i < count do
		i = i + 1
		table.remove(frametimes)
	end
	local fps = 1 / accum
	local rt = globals.realtime()
	if math.abs(fps - fps_prev) > 4 or rt - last_update_time > 2 then
		fps_prev = fps
		last_update_time = rt
	else
		fps = fps_prev
	end
	return math.floor(fps + 0.5)
end

 local is_inside = function(a, b, x, y, w, h) 
	return a >= x and a <= w and b >= y - 4 and b <= h 
end

 local function draw_indicator_circle(x, y, r, g, b, a, percentage, outline)
    local outline = outline == nil and true or outline
    local radius = 4
    local start_degrees = 0

     if outline then
        renderer.circle_outline(x, y, 0, 0, 0, 200, radius, start_degrees, 2, 4)
    end
    renderer.circle_outline(x, y, r, g, b, a, radius-1, start_degrees, percentage, 1.5)
end

 local should_draw = false

 local slider_double_tap_fake_lag_limit = ui.reference('rage', 'other', 'double tap fake lag limit')
local slider_sv_maxusrcmdprocessticks = ui.reference("misc", "settings", "sv_maxusrcmdprocessticks")

 local double_tap_started = false
local double_tap_started_tickcount = globals.tickcount()

--Override shit
override = ui.new_checkbox("AA", "Anti-aimbot angles", "[TEST] Resolver override")
override_key = ui.new_hotkey("AA", "Anti-aimbot angles", "[TEST] Override key")
override_indicator = ui.new_combobox("RAGE", "Other", "TEST] Indicator type", "-", "Default", "Crosshair")

--Override ref
selectedplayer = ui.reference("PLAYERS", "Players", "Player list")
forcebody = ui.reference("PLAYERS", "Adjustments", "Force body yaw")
resetlist = ui.reference("PLAYERS", "Players", "Reset all")
correction_active = ui.reference("PLAYERS", "Adjustments", "Correction active")
applyall = ui.reference("players", "adjustments", "Apply to all")
body_slider = ui.reference("PLAYERS", "Adjustments", "Force body yaw value")

--Override key

function setbodyyaw()
	if ui.get(override, true) then
	else
		return
	end
    ui.set(forcebody, ui.get(override_key) and true or false)
    ui.set(body_slider, ui.get(override_key) and 22 or 0)
    ui.set(applyall, ui.get(override_key) and true or false)
end

function on_paint()
	if ui.get(override, true) then
	else
		return
	end
	setbodyyaw()
end
client.set_event_callback("paint", on_paint)

--Override flag

client.register_esp_flag("lowdelta", 255, 0, 255, function(c)
	if ui.get(body_slider) == 22 then return true end
end)

--Override indicators

client.set_event_callback("paint", function()
	if ui.get(override, true) and ui.get(override_indicator) == "Default" then
		if ui.get(body_slider) == 22 then
			renderer.indicator(0, 255, 0, 255, "lowdelta")
		elseif ui.get(forcebody) == false then
			renderer.indicator(100, 100, 100, 255, "Normal")
		end
	end
end)

--Reset on round start
client.set_event_callback("round_start", function()
	ui.set(body_slider, 0)
	ui.set(forcebody, false)
	ui.set(applyall, true)
end)
local c1, c2, c3 = 0, 0, 0

local function time_to_ticks(time)
	return math.floor(time / globals.tickinterval() + .5)
end

local enabled_reference = ui.new_checkbox("AA", "Anti-aimbot angles", "[TEST] Clan tag spammer")
local default_reference = ui.reference("MISC", "Miscellaneous", "Clan tag spammer")

local clan_tag_prev = ""
local enabled_prev = false

local function gamesense_anim(text, indices)
	-- local text_anim = "               " .. text .. "                      " 
	-- local tickinterval = globals.tickinterval()
	-- local tickcount = globals.tickcount() + time_to_ticks(client.latency())
	-- local i = tickcount / time_to_ticks(0.3)
	-- i = math.floor(i % #indices)
	-- i = indices[i+1]+1

    -- return string.sub(text_anim, i, i+15)
    
    local text_anim
    local tickinterval = globals.tickinterval()
    local tickcount = globals.tickcount() + time_to_ticks(client.latency())
    local i = tickcount / time_to_ticks(0.2394834835)
    local sync_i = i % 6
    i = math.floor(i % #indices)
    if math.floor(sync_i) > 2 and i < 19 then
        text_anim = "            " .. text:sub(1, -1) .. "|            "
    else
        text_anim = "            " .. text .. "            "
    end
    i = indices[i+1]+1
    return string.sub(text_anim, i, i+12)
end

local function run_tag_animation()
	if ui.get(enabled_reference) then
		local clan_tag = gamesense_anim("TEST.yaw", {22,18,17,16,15,14,13,12,11,10,10,10,10,10,10,10,10,10,9,8,7,6,5,4,3,2,1,0,-1})
		if clan_tag ~= clan_tag_prev then
			client.set_clan_tag(clan_tag)
		end
		clan_tag_prev = clan_tag
	end
end

local once = false
local function on_paint(ctx)
    if ui.get(enabled_reference) then
        ui.set(default_reference, false)
        once = false
    else
        if not once then
            ui.set(default_reference, false)
            once = true
        end
    end
	local enabled = ui.get(enabled_reference)
	if enabled then
		local local_player = entity.get_local_player()
		if local_player ~= nil and (not entity.is_alive(local_player)) and globals.tickcount() % 2 == 0 then 
			run_tag_animation()
		end
	elseif enabled_prev then
		client.set_clan_tag("\0")
	end
	enabled_prev = enabled
end
client.set_event_callback("paint", on_paint)

local function on_run_command(e)
    if ui.get(enabled_reference) then
        ui.set(default_reference, false)
        once = false
    else
        if not once then
            ui.set(default_reference, false)
            once = true
        end
    end
	if ui.get(enabled_reference) then
		if e.chokedcommands == 0 then
			run_tag_animation()
		end
	end
end
client.set_event_callback("run_command", on_run_command)

local function draw_crosshair_indicators()
    local add_value = 0
    local body_yaw = entity.get_prop(entity.get_local_player(), 'm_flPoseParameter', 11)
	if not body_yaw then return end

 	local start_degrees = body_yaw >= 0.5 and 90 or 270

 	local float = 1 - math.abs((body_yaw - 0.5) * 2)

 	local r, g, b = get_color_by_float(float, 1)

 	local w, h = client.screen_size()
    local x, y = w / 2, h / 2

     local percentage = 60 * (1 / 360)

     local camera_yaw = select(2, client.camera_angles())
    local rotation_yaw = select(2, entity.get_prop(entity.get_local_player(), 'm_angAbsRotation'))

     local gr, gg, gb, ga = 180, 180, 180, 150
    local c_r, c_g, c_b, c_a = ui.get(side_clr)

     local s = not ui.get(change_aa_on_key) or not ui.get(jitter_aa)
    local arrow_s = contains(ui.get(anti_brute), "On miss") and s and should_draw

    
    local is_center = ui.get(indicator.font) ~= "Default centered" 
    and ui.get(indicator.font) ~= "Big centered"
    and ui.get(indicator.font) ~= "Bold centered"

    local style = ""
    if ui.get(indicator.font) == "Default" then style = "-" 
    elseif ui.get(indicator.font) == "Default centered" then style = "c-" 
    elseif ui.get(indicator.font) == "Big" then style = "" 
    elseif ui.get(indicator.font) == "Big centered" then style = "c" 
    elseif ui.get(indicator.font) == "Bold" then style = "b" 
    elseif ui.get(indicator.font) == "Bold centered" then style = "cb" end

     if ui.get(indicator_style) == "Circle" then
        if ui.get(byaw_based) then
            c1, c2, c3 = r, g, b
        else
            c1, c2, c3 = ui.get(byaw_clr)
        end 
        renderer.circle_outline(x, y, 0, 0, 0, 100, 10, 0, 1, 5)
        renderer.circle_outline(x, y, c1, c2, c3, 255, 9, start_degrees, 0.5, 3)
        renderer.circle_outline(x, y, c1, c2, c3, 255, 19, camera_yaw - rotation_yaw - 120, percentage, 4)
    elseif ui.get(indicator_style) == "Arrows" then
        local target = get_near_target()
        if target ~= nil then
            renderer.text(x + 45, y - 3, 
                body_yaw > 0.5 and gr or c_r, 
                body_yaw > 0.5 and gg or c_g, 
                body_yaw > 0.5 and gb or c_b,  
                body_yaw > 0.5 and ga or value3,  
            "cb+", 0, body_yaw < 0.5 and arrow_s and ">>" or ">")

             renderer.text(x - 45, y - 3, 
                body_yaw > 0.5 and c_r or gr, 
                body_yaw > 0.5 and c_g or gg, 
                body_yaw > 0.5 and c_b or gb,  
                body_yaw > 0.5 and value3 or ga,  
            "cb+", 0, body_yaw > 0.5 and arrow_s and "<<" or "<")
        end
    elseif ui.get(indicator_style) == "Circle + Arrows" then
        if ui.get(byaw_based) then
            c1, c2, c3 = r, g, b
        else
            c1, c2, c3 = ui.get(byaw_clr)
        end 

        renderer.circle_outline(x, y, 0, 0, 0, 100, 10, 0, 1, 5)
        renderer.circle_outline(x, y, c1, c2, c3, 255, 9, start_degrees, 0.5, 3)
        renderer.circle_outline(x, y, c1, c2, c3, 255, 19, camera_yaw - rotation_yaw - 120, percentage, 4)
    
        local target = get_near_target()
        if target ~= nil then
            renderer.text(x + 45, y - 3, 
                body_yaw > 0.5 and gr or c_r, 
                body_yaw > 0.5 and gg or c_g, 
                body_yaw > 0.5 and gb or c_b,  
                body_yaw > 0.5 and ga or value3,  
            "cb+", 0, body_yaw < 0.5 and arrow_s and ">>" or ">")

             renderer.text(x - 45, y - 3, 
                body_yaw > 0.5 and c_r or gr, 
                body_yaw > 0.5 and c_g or gg, 
                body_yaw > 0.5 and c_b or gb,  
                body_yaw > 0.5 and value3 or ga,  
            "cb+", 0, body_yaw > 0.5 and arrow_s and "<<" or "<")
        end

    elseif ui.get(indicator_style) == "Line" then
        body_yaw = body_yaw * 120 - 60
    
        local first_r, first_g, first_b, first_a = ui.get(line_clr1)
        local second_r, second_g, second_b, second_a = ui.get(line_clr2)
    
        local line_width = math.abs(math.floor(body_yaw + 0.5))

        local o = is_center and 23 or 30
        local o1 = is_center and 44 or 50

        renderer.text(x, y + o, 255, 255, 255, 255, style, 0, string.format('%s°', line_width))
    
        renderer.gradient(x - line_width, y + 40, line_width, 3, first_r, first_g, first_b, first_a, second_r, second_g, second_b, second_a, true)
        renderer.gradient(x, y + 40, line_width, 3, second_r, second_g, second_b, second_a, first_r, first_g, first_b, first_a, true)
    
        renderer.text(x, y + o1, 255, 255, 255, 255, style, 0, 'TEST')
    elseif ui.get(indicator_style) == "Arrows + Line" then
        local target = get_near_target()
        if target ~= nil then
            renderer.text(x + 45, y - 3, 
                body_yaw < 0.5 and gr or c_r, 
                body_yaw < 0.5 and gg or c_g, 
                body_yaw < 0.5 and gb or c_b,  
                body_yaw < 0.5 and ga or value3,  
            "cb+", 0, body_yaw > 0.5 and arrow_s and ">>" or ">")

             renderer.text(x - 45, y - 3, 
                body_yaw < 0.5 and c_r or gr, 
                body_yaw < 0.5 and c_g or gg, 
                body_yaw < 0.5 and c_b or gb,  
                body_yaw < 0.5 and value3 or ga,  
            "cb+", 0, body_yaw < 0.5 and arrow_s and "<<" or "<")
        end

        body_yaw = body_yaw * 120 - 60
    
        local first_r, first_g, first_b, first_a = ui.get(line_clr1)
        local second_r, second_g, second_b, second_a = ui.get(line_clr2)
    
        local line_width = math.abs(math.floor(body_yaw + 0.5))

        local o = is_center and 23 or 30
        local o1 = is_center and 44 or 50

        renderer.text(x, y + o, 255, 255, 255, 255, style, 0, string.format('%s°', line_width))
    
        renderer.gradient(x - line_width, y + 40, line_width, 3, first_r, first_g, first_b, first_a, second_r, second_g, second_b, second_a, true)
        renderer.gradient(x, y + 40, line_width, 3, second_r, second_g, second_b, second_a, first_r, first_g, first_b, first_a, true)
    
        renderer.text(x, y + o1, 255, 255, 255, 255, style, 0, 'TEST')
    end

 	if not ui.get(indicator.enable) then
		return
	end

 	--local aa_name = ui.get(change_aa_on_key) and "DODGE" or ui.get(legit_aa_on_key) and "LEGIT AA" or "IDEAL YAW"
	local crosshair_size = cvar.cl_crosshairsize:get_int()

    local position_value = 0
    if ui.get(indicator_style) == "Line" then
        position_value = is_center and crosshair_size + 54.8 or crosshair_size + 61
    else
        if ui.get(indicator_style) == "Arrows + Line" then
            position_value = is_center and crosshair_size + 52.5 or crosshair_size + 58
        else
            position_value = crosshair_size + 30
        end
    end

 	local anim = ui.get(on_shot2) and "HIDE" or ui.get(dt) and "ANIM" or "ANIM"

     local manual_side = ""
     local side_x = 0
    if not is_back then
        if is_left then 
            manual_side = "LEFT" 
            side_x = -50
        elseif is_right then 
            manual_side = "RIGHT" 
            side_x = 50
        end

        renderer.text((screen_size_x / 2) + side_x, (screen_size_y / 2) + position_value,
            255, 
            255, 
            255, 
            value3,  
            style, 0, manual_side) 
    end

    local ri, gi, bi, ai = 50, 50, 50, 255
    if ui.get(indicator_style) ~= "Line" and ui.get(indicator_style) ~= "Arrows + Line" then
        renderer.text(screen_size_x / 2, (screen_size_y / 2) + position_value + add_value,
            255, 
            255, 
            255, 
            255,  
            style, 0, "TEST") 
        add_value = add_value + 10
    end 

     local send_packet = globals.chokedcommands() == 0
    local tickcount = globals.tickcount()   

     local double_tap = ui.get(dt) and ui.get(dt2)

     if double_tap and send_packet then
        if not double_tap_started then
            double_tap_started_tickcount = tickcount
        end
        double_tap_started = true
    else
        double_tap_started_tickcount = tickcount
        double_tap_started = false
    end

     local sv_maxusrcmdprocessticks = ui.get(slider_sv_maxusrcmdprocessticks)
    local max_fake_lag_limit = sv_maxusrcmdprocessticks - 2

     local double_tap_fake_lag_limit = ui.get(slider_double_tap_fake_lag_limit)
    local max_double_tap_charged_ticks = math.max(1, math.min(15, max_fake_lag_limit - double_tap_fake_lag_limit))

     local charged_double_tap_ticks = tickcount - double_tap_started_tickcount

     local percentage = map(charged_double_tap_ticks, 1, max_double_tap_charged_ticks, 0, 1)

     if charged_double_tap_ticks ~= 0 then
        local offset = ui.get(indicator.font) ~= "Default centered" 
            and ui.get(indicator.font) ~= "Big centered"
            and ui.get(indicator.font) ~= "Bold centered"

        renderer.text(not offset and screen_size_x / 2 - 7 or screen_size_x / 2, (screen_size_y / 2) + position_value + add_value,
		ui.get(dt) and ui.get(dt2) and 1 or 128, 
		ui.get(dt) and ui.get(dt2) and 255 or 11, 
		ui.get(dt) and ui.get(dt2) and 1 or 11, 
		ui.get(dt) and ui.get(dt2) and 255 or 255,  
        style, 0, "DT")

        local shit = ui.get(indicator.font) == "Default" and 5 
        or ui.get(indicator.font) == "Big" and 7
        or ui.get(indicator.font) == "Bold" and 7 or 5

        local shit2 = ui.get(indicator.font) == "Default" and 16
        or ui.get(indicator.font) == "Big" and 18
        or ui.get(indicator.font) == "Bold" and 19 or 16

         draw_indicator_circle(not offset and screen_size_x / 2 + 7 or screen_size_x / 2 + shit2, not offset and (screen_size_y / 2) + position_value + add_value + 1 
         or (screen_size_y / 2) + position_value + add_value + shit, 1, 255, 1, 255, percentage)
    else
        renderer.text(screen_size_x / 2, (screen_size_y / 2) + position_value + add_value,
		ui.get(dt) and ui.get(dt2) and 1 or 128, 
		ui.get(dt) and ui.get(dt2) and 255 or 11, 
		ui.get(dt) and ui.get(dt2) and 1 or 11, 
		ui.get(dt) and ui.get(dt2) and 255 or 255,  
		style, 0, "DT")
    end

 	add_value = add_value + 10

    local target = get_near_target()

    local AA = ui.get(aa_mode) == "Jitter" and "DYNAMIC" or "DEFAULT"

    renderer.text(screen_size_x / 2, (screen_size_y / 2) + position_value + add_value,
        AA == "DYNAMIC" and 209 or 255, 
        AA == "DYNAMIC" and 139 or 255, 
        AA == "DYNAMIC" and 230 or 255, 
        255,  
        style, 0, AA) 
    add_value = add_value + 10

    local s = not ui.get(change_aa_on_key) or not ui.get(jitter_aa)
    if contains(ui.get(anti_brute), "On miss") and s then
        if should_draw then
            renderer.text(screen_size_x / 2, (screen_size_y / 2) + position_value + add_value,
            255,  
            255,  
            255,  
            255,  
            style, 0, "SMART")
            add_value = add_value + 10
        end
    end

 	if ui.get(on_shot) and ui.get(on_shot2) then
		renderer.text(screen_size_x / 2, (screen_size_y / 2) + position_value + add_value,
		255,  
		102,  
		102,  
		255,  
		style, 0, "ON-SHOT")
		add_value = add_value + 10
	end
	if ui.get(fd) then
		renderer.text(screen_size_x / 2, (screen_size_y / 2) + position_value + add_value,
			255, 
			255, 
			255, 
			value3,  
			style, 0, "DUCK")
		add_value = add_value + 10
	end
	if ui.get(sf) then
		renderer.text(screen_size_x / 2, (screen_size_y / 2) + position_value + add_value,
		128,  
		200,  
		0,  
		255,
		style, 0, "SAFE")
		add_value = add_value + 10
	end
	if ui.get(baim) then
		renderer.text(screen_size_x / 2, (screen_size_y / 2) + position_value + add_value,
			128,  
			240,  
			0,  
			255,  
			style, 0, "BAIM")
		add_value = add_value + 10
    end
    
    if ui.get(override, true) and ui.get(override_indicator) == "Crosshair" then
        if ui.get(body_slider) == 22 then
            renderer.text(screen_size_x / 2, (screen_size_y / 2) + position_value + add_value,
            0,  
            255,  
            0,  
            255,  
            style, 0, "LOWDELTA")
		elseif ui.get(forcebody) == false then
            renderer.text(screen_size_x / 2, (screen_size_y / 2) + position_value + add_value,
            100,  
            100,  
            100,  
            255,  
            style, 0, "DEFAULT")
        end
        
        add_value = add_value + 10
	end
end 

 client.set_event_callback("paint", function(ctx)
	if not ui.get(enable_lua) then
		return
	end

	if not entity.is_alive(entity.get_local_player()) then return end

 	local old_x, old_y = client.screen_size()	

	if screen_size_x ~= old_x or screen_size_y ~= old_y then
		screen_size_x = old_x
		screen_size_y = old_y
	end

	ui.set(vars.key_left, "On hotkey")
	ui.set(vars.key_right, "On hotkey")
	ui.set(vars.key_back, "On hotkey")

	draw_crosshair_indicators()
	get_direction()
	set_direction()

end)

 local get_closeset_point = function(a, b, p)
    local a_to_p = { p[1] - a[1], p[2] - a[2] }
    local a_to_b = { b[1] - a[1], b[2] - a[2] }

     local atb2 = a_to_b[1]^2 + a_to_b[2]^2

     local atp_dot_atb = a_to_p[1]*a_to_b[1] + a_to_p[2]*a_to_b[2]
    local t = atp_dot_atb / atb2

     return { a[1] + a_to_b[1]*t, a[2] + a_to_b[2]*t }
end

 local should_swap = false
local it = 0

 local on_bullet_impact = function(c)
    if not contains(ui.get(anti_brute), "On miss") then
        return
    end
    should_draw = false

     if entity.is_alive(entity.get_local_player()) then
        local ent = client.userid_to_entindex(c.userid)

         if not entity.is_dormant(ent) and entity.is_enemy(ent) then
            local ent_shoot = { entity.get_prop(ent, "m_vecOrigin") }

             ent_shoot[3] = ent_shoot[3] + entity.get_prop(ent, "m_vecViewOffset[2]")

             local player_head = { entity.hitbox_position(entity.get_local_player(), 0) }
            local closest = get_closeset_point(ent_shoot, { c.x, c.y, c.z }, player_head)
            local delta = { player_head[1]-closest[1], player_head[2]-closest[2] }
            local delta_2d = math.sqrt(delta[1]^2+delta[2]^2)
        
            if math.abs(delta_2d) < 125 then
                it = it + 1

                 should_draw = true

                 if should_swap == true then
                    should_swap = false
                else
                    should_swap = true
                end
            end
        end
    end
end

 local on_player_hurt = function(e)
    if not contains(ui.get(anti_brute), "On hit") then
        return
    end

     local victim_userid, attacker_userid = e.userid, e.attacker
	local victim_entindex = client.userid_to_entindex(victim_userid)
    local attacker_entindex = client.userid_to_entindex(attacker_userid)

     local state = true

     if state and entity.is_enemy(attacker_entindex) and victim_entindex == entity.get_local_player() then
        if should_swap == true then
            should_swap = false
        else
            should_swap = true
        end
    end
end

 client.set_event_callback('bullet_impact', on_bullet_impact)
client.set_event_callback('player_hurt', on_player_hurt)
client.set_event_callback("aim_fire", function()
    if not contains(ui.get(anti_brute), "On shot") then
        return
    end
    if should_swap == true then
        should_swap = false
    else
        should_swap = true
    end
end)

 client.set_event_callback("run_command", function(c)
	if not ui.get(enable_lua) or ui.get(change_aa_on_key) or ui.get(jitter_aa) then
		return
    end

     if contains(ui.get(anti_brute), "-") then
        return
    end

	ui.set(body_add, should_swap and 154 or -146)
end)

 local flip = false
function reset_antiaim_values()
	if ui.get(enable_lua) then
		flip  = true
	end

 	if flip and not ui.get(enable_lua) then
		ui.set(pitch, "Down")
		ui.set(yaw, "180")
		ui.set(yaw_add, 0)
		ui.set(jitter, "Off")
		ui.set(jitter2, 0)
		ui.set(yaw_base, "Local view")
		ui.set(body, "Static")
		ui.set(body_add, 0)
		ui.set(lby, "Eye yaw")
		ui.set(freestand_byaw, false)
		ui.set(yaw_limit, 60)
		flip = false
	end
end

 local legs_ref = ui.reference("AA", "OTHER", "leg movement")

 local function legfucker()
  if ui.get(aa_legs) then
    local legs_int = math.random(0, 10)
    if legs_int <= 4 then
      ui.set(legs_ref, "always slide")
    end
    if legs_int == 0 then
      ui.set(legs_ref, "never slide")
    end
    if legs_int >= 5 then
      ui.set(legs_ref, "never slide")
    end
  end
end
client.set_event_callback('paint', legfucker)


local show_preset, show_def = true

local set_preset = ui.new_button("AA", "Anti-aimbot angles", "Set mishkat's preset", function()
    ui.set(legit_aa, true)
    ui.set(legit_aa_mode, "On use (e button)")
    ui.set(aa_mode, "Jitter")
    ui.set(jitter_aa, false)
    ui.set(jitter_dormant, true)
    ui.set(vars.enable, true)
    ui.set(auto_invert, true)
    ui.set(anti_brute, "On hit", "On miss")
    ui.set(indicator_style, "Circle + Arrows")
    ui.set(indicator.font, "Bold centered")
    ui.set(aa_legs, true)
    ui.set(aa_enabled, true)
    ui.set(watermark111, true)
    ui.set(indicator.enable, true)
    show_preset = false
    show_def = true
end)

local reset_preset = ui.new_button("AA", "Anti-aimbot angles", "Reset to default", function()
    ui.set(legit_aa, false)
    ui.set(legit_aa_mode, "On key")
    ui.set(aa_mode, "Static")
    ui.set(vars.enable, false)
    ui.set(jitter_aa, false)
    ui.set(jitter_dormant, false)
    ui.set(auto_invert, false)
    ui.set(anti_brute, "-")
    ui.set(indicator_style, "Off")
    ui.set(aa_legs, false)
    ui.set(aa_enabled, false)
    ui.set(watermark111, false)
    ui.set(indicator.enable, false)
    ui.set(indicator.font, "Default")
    show_preset = true
    show_def = false
end)

 function set_visible_on_elements()
    local is_aa = ui.get(lua_tab) == "Anti-aim"
    local is_indicator = ui.get(lua_tab) == "Indication"
    local is_misc = ui.get(lua_tab) == "Misc"

    local shit = is_indicator and (ui.get(indicator_style) == "Arrows" or ui.get(indicator_style) == "Arrows + Line")
    local shit2 = is_indicator and (ui.get(indicator_style) == "Line" or ui.get(indicator_style) == "Arrows + Line")

    local shit3 = is_indicator and (ui.get(indicator_style) == "Circle" or ui.get(indicator_style) == "Circle + Arrows")
    local shit4 = is_indicator and (ui.get(indicator_style) == "Arrows" or ui.get(indicator_style) == "Circle + Arrows")

    -- override = ui.new_checkbox("AA", "Anti-aimbot angles", "Resolver override")
    -- override_key = ui.new_hotkey("AA", "Anti-aimbot angles", "Override key")
    -- override_indicator = ui.new_combobox("RAGE", "Other", "Indicator type", "-", "Default", "Crosshair")

	ui.set_visible(pitch, not ui.get(enable_lua))
	ui.set_visible(yaw, not ui.get(enable_lua))
	ui.set_visible(legs_ref, not ui.get(aa_legs))
	ui.set_visible(yaw_add, not ui.get(enable_lua))
	ui.set_visible(jitter, not ui.get(enable_lua))
	ui.set_visible(jitter2, not ui.get(enable_lua))
	ui.set_visible(yaw_base, not ui.get(enable_lua))
	ui.set_visible(body, not ui.get(enable_lua))
	ui.set_visible(body_add, not ui.get(enable_lua))
	ui.set_visible(lby, not ui.get(enable_lua))
	ui.set_visible(freestand_byaw, not ui.get(enable_lua))
	ui.set_visible(yaw_limit, not ui.get(enable_lua))
	reset_antiaim_values()

    ui.set_visible(lua_tab, ui.get(enable_lua))
    
    ui.set_visible(override, ui.get(enable_lua)  and is_misc) 
    ui.set_visible(override_key, ui.get(enable_lua) and ui.get(override) and is_misc)
    ui.set_visible(override_indicator, ui.get(enable_lua) and ui.get(override) and is_misc)

    ui.set_visible(aa_enabled, ui.get(enable_lua) and is_indicator)
    ui.set_visible(jitter_dormant, ui.get(enable_lua) and is_aa)
    ui.set_visible(watermark111, ui.get(enable_lua) and is_indicator)

    ui.set_visible(aa_mode, ui.get(enable_lua) and is_aa)
    ui.set_visible(jitter_aa, ui.get(enable_lua) and is_aa)
    ui.set_visible(legit_aa, ui.get(enable_lua) and is_aa)
    ui.set_visible(legit_aa_mode, ui.get(enable_lua) and ui.get(legit_aa) and is_aa)
    ui.set_visible(legit_aa_key, ui.get(enable_lua) and ui.get(legit_aa) and ui.get(legit_aa_mode) == "On key" and is_aa) 
    ui.set_visible(indicator.enable, ui.get(enable_lua) and is_indicator)
    ui.set_visible(indicator.font, ui.get(enable_lua) and ui.get(indicator.enable) and is_indicator)
    ui.set_visible(vars.enable, ui.get(enable_lua) and is_aa)
	ui.set_visible(vars.key_left, ui.get(enable_lua) and ui.get(vars.enable) and is_aa)
	ui.set_visible(vars.key_right, ui.get(enable_lua) and ui.get(vars.enable) and is_aa)
	ui.set_visible(vars.key_back, ui.get(enable_lua) and ui.get(vars.enable) and is_aa)
	ui.set_visible(aa_legs, ui.get(enable_lua) and is_misc)
	ui.set_visible(change_aa_on_key, ui.get(enable_lua) and is_aa)
    ui.set_visible(auto_invert, ui.get(enable_lua) and is_aa)
    ui.set_visible(anti_brute, ui.get(enable_lua) and is_aa)
    ui.set_visible(indicator_style, ui.get(enable_lua) and is_indicator)
    ui.set_visible(byaw_label, ui.get(enable_lua) and shit3 and not ui.get(byaw_based))
    ui.set_visible(byaw_clr, ui.get(enable_lua) and shit3 and not ui.get(byaw_based))
    ui.set_visible(byaw_based, ui.get(enable_lua) and shit3)
    ui.set_visible(side_label, ui.get(enable_lua) and shit or shit4)
    ui.set_visible(side_clr, ui.get(enable_lua) and shit or shit4)
    ui.set_visible(line_clr1, ui.get(enable_lua) and shit2)
    ui.set_visible(line_clr2, ui.get(enable_lua) and shit2)
    ui.set_visible(line_label1, ui.get(enable_lua) and shit2)
    ui.set_visible(line_label2, ui.get(enable_lua) and shit2)
    ui.set_visible(set_preset, ui.get(enable_lua) and show_preset and is_misc)
    ui.set_visible(reset_preset, ui.get(enable_lua) and show_def and is_misc)
    ui.set_visible(enabled_reference, ui.get(enable_lua) and is_misc)
    ui.set_visible(edge_key, ui.get(enable_lua) and is_misc)
    ui.set_visible(misc_onpeek, ui.get(enable_lua) and is_misc)
    ui.set(freestand_byaw, ui.get(enable_lua) and not ui.get(change_aa_on_key) and ui.get(auto_invert))
    ui.set(edge_yaw, ui.get(enable_lua) and ui.get(edge_key))
end

 client.set_event_callback("paint_menu", set_visible_on_elements)
client.set_event_callback("paint", set_visible_on_elements)

local function map(n, start, stop, new_start, new_stop)
    local value = (n - start) / (stop - start) * (new_stop - new_start) + new_start

     return new_start < new_stop and math.max(math.min(value, new_stop), new_start) or math.max(math.min(value, new_start), new_stop)
end
