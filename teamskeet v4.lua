-- local variables for API functions. any changes to the line below will be lost on re-generation
local bit_band, client_camera_angles, client_color_log, client_create_interface, client_eye_position, client_log, client_random_int, client_scale_damage, client_screen_size, client_set_event_callback, client_trace_bullet, client_userid_to_entindex, entity_get_local_player, entity_get_player_weapon, entity_get_players, entity_get_prop, entity_hitbox_position, entity_is_alive, entity_is_enemy, globals_curtime, math_abs, math_atan, math_atan2, math_cos, math_deg, math_floor, math_max, math_min, math_rad, math_sin, math_sqrt, renderer_circle, renderer_circle_outline, renderer_gradient, renderer_line, renderer_rectangle, renderer_text, renderer_triangle, require, print, string_find, string_gmatch, string_gsub, string_lower, ui_get, ui_is_menu_open, ui_mouse_position, ui_new_checkbox, ui_new_color_picker, ui_new_combobox, ui_new_hotkey, ui_new_multiselect, ui_new_slider, ui_reference, ui_set	, ui_set_callback, ui_set_visible, tonumber, tostring, renderer_measure_text, client_key_state = bit.band, client.camera_angles, client.color_log, client.create_interface, client.eye_position, client.log, client.random_int, client.scale_damage, client.screen_size, client.set_event_callback, client.trace_bullet, client.userid_to_entindex, entity.get_local_player, entity.get_player_weapon, entity.get_players, entity.get_prop, entity.hitbox_position, entity.is_alive, entity.is_enemy, globals.curtime, math.abs, math.atan, math.atan2, math.cos, math.deg, math.floor, math.max, math.min, math.rad, math.sin, math.sqrt, renderer.circle, renderer.circle_outline, renderer.gradient, renderer.line, renderer.rectangle, renderer.text, renderer.triangle, require, print, string.find, string.gmatch, string.gsub, string.lower, ui.get, ui.is_menu_open, ui.mouse_position, ui.new_checkbox, ui.new_color_picker, ui.new_combobox, ui.new_hotkey, ui.new_multiselect, ui.new_slider, ui.reference, ui.set, ui.set_callback, ui.set_visible, tonumber, tostring, renderer.measure_text, client.key_state
local ui_menu_position, ui_menu_size, math_pi, renderer_indicator, entity_is_dormant, client_set_clan_tag, client_trace_line, entity_get_all, entity_get_classname = ui.menu_position, ui.menu_size, math.pi, renderer.indicator, entity.is_dormant, client.set_clan_tag, client.trace_line, entity.get_all, entity.get_classname

local vector = require('vector')
local ffi = require('ffi')
local ffi_cast = ffi.cast

ffi.cdef [[
	typedef int(__thiscall* get_clipboard_text_count)(void*);
	typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);
	typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);
]]

--[ VGUI_System ]--
local VGUI_System010 =  client_create_interface("vgui2.dll", "VGUI_System010") or print( "Error finding VGUI_System010")
local VGUI_System = ffi_cast( ffi.typeof( "void***" ), VGUI_System010 )

local get_clipboard_text_count = ffi_cast( "get_clipboard_text_count", VGUI_System[ 0 ][ 7 ] ) or print( "get_clipboard_text_count Invalid")
local set_clipboard_text = ffi_cast( "set_clipboard_text", VGUI_System[ 0 ][ 9 ] ) or print( "set_clipboard_text Invalid")
local get_clipboard_text = ffi_cast( "get_clipboard_text", VGUI_System[ 0 ][ 11 ] ) or print( "get_clipboard_text Invalid")

local ts_clantag = {
	"teamskeet.lua ",
	"eamskeet.lua t",
	"amskeet.lua te",
	"mskeet.lua tea",
	"skeet.lua team",
	"keet.lua teams",
	"eet.lua teamsk",
	"et.lua teamske",
	"t.lua teamskee",
	".lua teamskeet",
	"lua teamskeet.",
	"ua teamskeet.l",
	"a teamskeet.lu",
	" teamskeet.lua"
}

local maxproc = ui_reference("MISC", "Settings", "sv_maxusrcmdprocessticks")

ui.set_visible(maxproc, true)

--[ Functions ]--
local function clipboard_import( )
  	local clipboard_text_length = get_clipboard_text_count( VGUI_System )
	local clipboard_data = ""

	if clipboard_text_length > 0 then
		buffer = ffi.new("char[?]", clipboard_text_length)
		size = clipboard_text_length * ffi.sizeof("char[?]", clipboard_text_length)

		get_clipboard_text( VGUI_System, 0, buffer, size )

		clipboard_data = ffi.string( buffer, clipboard_text_length-1 )
	end
	return clipboard_data
end

local function clipboard_export(string)
	if string then
		set_clipboard_text(VGUI_System, string, string:len())
	end
end

local ref = {
	enabled = ui_reference("AA", "Anti-aimbot angles", "Enabled"),
	pitch = ui_reference("AA", "Anti-aimbot angles", "pitch"),
    yawbase = ui_reference("AA", "Anti-aimbot angles", "Yaw base"),
    fakeyawlimit = ui_reference("AA", "anti-aimbot angles", "Fake yaw limit"),
    fsbodyyaw = ui_reference("AA", "anti-aimbot angles", "Freestanding body yaw"),
    lowerbodyyaw = ui_reference("AA", "Anti-aimbot angles", "Lower body yaw target"),
    edgeyaw = ui_reference("AA", "Anti-aimbot angles", "Edge yaw"),
    maxprocticks = ui_reference("MISC", "Settings", "sv_maxusrcmdprocessticks"),
    fakeduck = ui_reference("RAGE", "Other", "Duck peek assist"),
    safepoint = ui_reference("RAGE", "Aimbot", "Force safe point"),
    forcebaim = ui_reference("RAGE", "Other", "Force body aim"),
}

local ref_quickpeek, ref_quickpeekkey = ui_reference("RAGE", "Other", "Quick peek assist")
local ref_yaw, ref_yawadd = ui_reference("AA", "Anti-aimbot angles", "Yaw")
local ref_yawjitter, ref_yawjitteradd = ui_reference("AA", "Anti-aimbot angles", "Yaw jitter")
local ref_bodyyaw, ref_bodyyawadd = ui_reference("AA", "Anti-aimbot angles", "Body yaw")
local ref_freestand, ref_freestandkey = ui_reference("AA", "Anti-aimbot angles", "Freestanding")
local ref_os, ref_oskey = ui_reference("AA", "Other", "On shot anti-aim")
local ref_slow, ref_slowkey = ui_reference("AA", "Other", "Slow motion")
local ref_dt, ref_dtkey = ui_reference("RAGE", "Other", "Double tap")
local ref_ps, ref_pskey, ref_psamount = ui_reference("MISC", "Miscellaneous", "Ping spike")
local ref_fakelag, ref_fakelagkey = ui_reference("AA", "Fake lag", "Enabled")

local player_states = {"Global", "Standing", "Moving", "Slow motion", "Air", "On-key"}
local state_to_idx = {["Global"] = 1, ["Standing"] = 2, ["Moving"] = 3, ["Slow motion"] = 4, ["Air"] = 5, ["On-key"] = 6}
local player_state = ui_new_combobox("AA", "Anti-aimbot angles", "Player state", player_states)
local onshot_aa_settings, onshot_aa_key = ui_new_multiselect("AA", "Other", "On shot anti-aim", {"While standing", "While moving", "On slow-mo", "In air", "While crouching", "On key"}), ui_new_hotkey("AA", "Other", "On shot anti-aim key", false)

local aa_dir   = 0
local active_i = 1
local p_state = 0
local anti_aim = { }
for i=1, 6 do
	anti_aim[i] = {
        enable = i == 6 and ui_new_hotkey("AA", "Anti-aimbot angles", "Enable " .. string_lower(player_states[i]) .. " anti-aim") or ui_new_checkbox("AA", "Anti-aimbot angles", "Enable " .. string_lower(player_states[i]) .. " anti-aim"),
		pitch = ui_new_combobox("AA", "Anti-aimbot angles", "Pitch\n" .. player_states[i], { "Off", "Default", "Up", "Down", "Minimal", "Random" }),
		yawbase = ui_new_combobox("AA", "Anti-aimbot angles", "Yaw base\n" .. player_states[i], { "Local view", "At targets" }),
		yaw = ui_new_combobox("AA", "Anti-aimbot angles", "Yaw\n" .. player_states[i], { "Off", "180", "Spin", "Static", "180 Z", "Crosshair" }),
		yawadd = ui_new_slider("AA", "Anti-aimbot angles", "\nYaw add" .. player_states[i], -180, 180, 0),
		yawjitter = ui_new_combobox("AA", "Anti-aimbot angles", "Yaw jitter\n" .. player_states[i], { "Off", "Offset", "Center", "Random" }),
		yawjitteradd = ui_new_slider("AA", "Anti-aimbot angles", "\nYaw jitter add" .. player_states[i], -180, 180, 0),
		aa_mode = ui_new_combobox("AA", "Anti-aimbot angles", "Body yaw type\n" .. player_states[i], {"Teamskeet", "Gamesense"}),
		gs_bodyyaw = ui_new_combobox("AA", "Anti-aimbot angles", "Body yaw\n GS" .. player_states[i], { "Off", "Opposite", "Jitter", "Static" }),
		gs_bodyyawadd = ui_new_slider("AA", "Anti-aimbot angles", "\nBody yaw add" .. player_states[i], -180, 180, 0),
		bodyyaw = ui_new_combobox("AA", "Anti-aimbot angles", "Body yaw\n" .. player_states[i], { "Off", "Opposite", "Freestanding", "Reversed Freestanding", "Jitter", "Switch key"}),
		bodyyaw_settings = ui_new_multiselect("AA", "Anti-aimbot angles", "Body yaw settings\n" .. player_states[i], { "Jitter when vulnerable", "Anti-resolver", "Detect missed angle"}),
		lowerbodyyaw = ui_new_combobox("AA", "Anti-aimbot angles", "Lower body yaw\n" .. player_states[i], { "Off", "Sway", "Half sway", "Opposite", "Eye yaw"}),
		fakeyawlimit = ui_new_slider("AA", "Anti-aimbot angles", "Fake yaw limit\n" .. player_states[i], 0, 60, 60),
		fakeyawmode = ui_new_combobox("AA", "Anti-aimbot angles", "Customize fake yaw limit\n" .. player_states[i], { "Off", "Jitter", "Random", "Custom right" }),
		fakeyawamt = ui_new_slider("AA", "Anti-aimbot angles", "\nFake yaw randomization" .. player_states[i], 0, 60, 0),
		gs_edgeyaw = ui_new_checkbox("AA", "Anti-aimbot angles", "Edge yaw\n" .. player_states[i]),
	}
end
ui_set(anti_aim[1].enable, true)
ui_set_visible(anti_aim[1].enable, false)

local aa_settings = ui_new_multiselect("AA", "Fake lag", "Anti-aim settings", {"Anti-aim on use", "Disable use to plant"})

local manual_enable = ui_new_checkbox("AA", "Anti-aimbot angles", "Manual anti-aim")
local manual_left = ui_new_hotkey("AA", "Anti-aimbot angles", "Manual left")
local manual_right = ui_new_hotkey("AA", "Anti-aimbot angles", "Manual right")
local manual_back = ui_new_hotkey("AA", "Anti-aimbot angles", "Manual back")
local switch_k = ui_new_hotkey("AA", "Anti-aimbot angles", "Body yaw switch key")
local freestand_key = ui_new_hotkey("AA", "Anti-aimbot angles", "Freestanding key")

local ind_set = ui_new_multiselect("AA", "Other", "Teamskeet ESP", {"Indicators", "Key states", "Anti-aim", "Clantag"})
local ind_sli = ui_new_multiselect("AA", "Other", "Indicator settings", {"Desync", "Fake lag", "Speed", "Gradient", "Show values", "Big", "Remove skeet indicators"})
local ind_clr = ui_new_color_picker("AA", "Other", "Indicator color picker", 175, 255, 0, 255)
local aa_ind_type = ui_new_combobox("AA", "Other", "Anti-aim indicator type", {"Arrows", "Circle", "Static"})
local ind_clr2 = ui_new_color_picker("AA", "Other", "Indicator desync color", 0, 200, 255, 255)

local pos_x = ui_new_slider("LUA", "B", "\nSaved Position X TS INDICATOR", 0, 10000, 10)
local pos_y = ui_new_slider("LUA", "B", "\nSaved Position Y TS INDICATOR", 0, 10000, 420)
ui_set_visible(pos_x, false)
ui_set_visible(pos_y, false)

local custom_keys = {}
local custom_key_saves = {}

local miss, hit, shots, last_hit, stored_misses, stored_shots, last_nn = {}, {}, {}, {}, {}, {}, 0
for i=1, 64 do
    miss[i], hit[i], shots[i], last_hit[i], stored_misses[i], stored_shots[i] = {}, {}, {}, 0, 0, 0
	for k=1, 3 do
		miss[i][k], hit[i][k], shots[i][k] = {}, {}, {}
		for j=1, 1000 do
			miss[i][k][j], hit[i][k][j], shots[i][k][j] = 0, 0, 0
		end
	end
	miss[i][4], hit[i][4], shots[i][4] = 0, 0, 0
end

local function contains(table, value)
    table = ui_get(table)
    for i=0, #table do
        if table[i] == value then
            return true
        end
    end
    return false
end

ui_set_callback(aa_settings, function()
	if not contains(aa_settings, "Anti-aim on use") then
		ui_set(aa_settings, "-")
	end
end)

local function set_og_menu(state)
	ui_set_visible(ref.pitch, state)
	ui_set_visible(ref.yawbase, state)
	ui_set_visible(ref_yaw, state)
	ui_set_visible(ref_yawadd, state)
	ui_set_visible(ref_yawjitter, state)
	ui_set_visible(ref_yawjitteradd, state)
	ui_set_visible(ref_bodyyaw, state)
	ui_set_visible(ref_bodyyawadd, state)
	ui_set_visible(ref.fakeyawlimit, state)
	ui_set_visible(ref.fsbodyyaw, state)
	ui_set_visible(ref.edgeyaw, state)
	ui_set_visible(ref_freestand, state)
	ui_set_visible(ref_freestandkey, state)
	ui_set_visible(ref.lowerbodyyaw, state)
	ui_set_visible(ref_os, state)
	ui_set_visible(ref_oskey, state)
end

local function handle_menu()
    active_i = state_to_idx[ui_get(player_state)]
	set_og_menu(false)
	
	local sk = false

    for i=1, 6 do
        ui_set_visible(anti_aim[i].enable, active_i == i and i > 1)
        ui_set_visible(anti_aim[i].pitch, active_i == i)
		ui_set_visible(anti_aim[i].yawbase, active_i == i)
		ui_set_visible(anti_aim[i].yaw, active_i == i)
		ui_set_visible(anti_aim[i].yawadd, active_i == i and ui_get(anti_aim[active_i].yaw) ~= "Off")
		ui_set_visible(anti_aim[i].yawjitter, active_i == i)
		ui_set_visible(anti_aim[i].yawjitteradd, active_i == i and ui_get(anti_aim[active_i].yawjitter) ~= "Off")

		local gs_aa = ui_get(anti_aim[i].aa_mode) == "Gamesense"
		ui_set_visible(anti_aim[i].aa_mode, active_i == i)

		ui_set_visible(anti_aim[i].gs_bodyyaw, gs_aa and active_i == i)
		ui_set_visible(anti_aim[i].gs_bodyyawadd, gs_aa and active_i == i and ui_get(anti_aim[i].gs_bodyyaw) ~= "Off" and ui_get(anti_aim[i].gs_bodyyaw) ~= "Opposite")
		ui_set_visible(anti_aim[i].gs_edgeyaw, active_i == i)

		ui_set_visible(anti_aim[i].bodyyaw, active_i == i and not gs_aa)
		ui_set_visible(anti_aim[i].bodyyaw_settings, not gs_aa and active_i == i and ui_get(anti_aim[i].bodyyaw) ~= "Off")

		ui_set_visible(anti_aim[i].lowerbodyyaw, active_i == i)
		ui_set_visible(anti_aim[i].fakeyawlimit, active_i == i)
		ui_set_visible(anti_aim[i].fakeyawmode, active_i == i)
		ui_set_visible(anti_aim[i].fakeyawamt, active_i == i and ui_get(anti_aim[i].fakeyawmode) ~= "Off")

		if ui_get(anti_aim[i].bodyyaw) == "Switch key" and ui_get(anti_aim[i].enable) then
			sk = true
		end
	end
	ui_set_visible(switch_k, ui_get(anti_aim[active_i].bodyyaw) == "Switch key")
	ui_set_visible(aa_ind_type, contains(ind_set, "Anti-aim"))
	ui_set_visible(ind_clr2, contains(ind_set, "Anti-aim"))
	ui_set_visible(manual_left, ui_get(manual_enable))
	ui_set_visible(manual_right, ui_get(manual_enable))
	ui_set_visible(manual_back, ui_get(manual_enable))
end
handle_menu()

local function normalize_yaw(yaw)
	while yaw > 180 do yaw = yaw - 360 end
	while yaw < -180 do yaw = yaw + 360 end
	return yaw
end

local function round(num, decimals)
	local mult = 10^(decimals or 0)
	return math_floor(num * mult + 0.5) / mult
end

local function calc_angle(local_x, local_y, enemy_x, enemy_y)
	local ydelta = local_y - enemy_y
	local xdelta = local_x - enemy_x
	local relativeyaw = math_atan( ydelta / xdelta )
	relativeyaw = normalize_yaw( relativeyaw * 180 / math_pi )
	if xdelta >= 0 then
		relativeyaw = normalize_yaw(relativeyaw + 180)
	end
	return relativeyaw
end

local iter = 1
local function rotate_string()
	local ret_str = ts_clantag[iter]
	if iter < 14 then
		iter = iter + 1
	else
		iter = 1
	end
	return ret_str
end

local function arr_to_string(arr)
	arr = ui_get(arr)
	local str = ""
	for i=1, #arr do
		str = str .. arr[i] .. (i == #arr and "" or ",")
	end

	if str == "" then
		str = "-"
	end

	return str
end

local function str_to_sub(input, sep)
	local t = {}
	for str in string_gmatch(input, "([^"..sep.."]+)") do
		t[#t + 1] = string_gsub(str, "\n", "")
	end
	return t
end

local function to_boolean(str)
	if str == "true" or str == "false" then
		return (str == "true")
	else
		return str
	end
end

local hotkey_modes1 = { "ALWAYS ON", "HELD", "TOGGLED", "OFF HOTKEY" }
local hotkey_modes = { "Always on", "On hotkey", "Toggle", "Off hotkey" }
local function get_key_mode(ref, secondary)
	local k = { ui_get(ref) }

    return secondary == nil and hotkey_modes[k[2] + 1] or hotkey_modes1[k[2] + 1]
end

local function angle_vector(angle_x, angle_y)
	local sy = math_sin(math_rad(angle_y))
	local cy = math_cos(math_rad(angle_y))
	local sp = math_sin(math_rad(angle_x))
	local cp = math_cos(math_rad(angle_x))
	return cp * cy, cp * sy, -sp
end

local function get_eye_pos(ent)
	local x, y, z = entity_get_prop(ent, "m_vecOrigin")
	local hx, hy, hz = entity_hitbox_position(ent, 0)
	return x, y, hz
end

local function rotate_point(x, y, rot, size)
	return math_cos(math_rad(rot)) * size + x, math_sin(math_rad(rot)) * size + y
end

local function renderer_arrow(x, y, r, g, b, a, rotation, size)
	local x0, y0 = rotate_point(x, y, rotation, 45)
	local x1, y1 = rotate_point(x, y, rotation + (size / 3.5), 45 - (size / 4))
	local x2, y2 = rotate_point(x, y, rotation - (size / 3.5), 45 - (size / 4))
	renderer_triangle(x0, y0, x1, y1, x2, y2, r, g, b, a)
end

local function calc_shit(xdelta, ydelta)
    if xdelta == 0 and ydelta == 0 then
        return 0
	end
	
    return math_deg(math_atan2(ydelta, xdelta))
end

local function get_damage(plocal, enemy, x, y,z)
	local ex = { }
	local ey = { }
	local ez = { }
	ex[0], ey[0], ez[0] = entity_hitbox_position(enemy, 1)
	ex[1], ey[1], ez[1] = ex[0] + 40, ey[0], ez[0]
	ex[2], ey[2], ez[2] = ex[0], ey[0] + 40, ez[0]
	ex[3], ey[3], ez[3] = ex[0] - 40, ey[0], ez[0]
	ex[4], ey[4], ez[4] = ex[0], ey[0] - 40, ez[0]
	ex[5], ey[5], ez[5] = ex[0], ey[0], ez[0] + 40
	ex[6], ey[6], ez[6] = ex[0], ey[0], ez[0] - 40
	local bestdamage = 0
	local bent = nil
	for i=0, 6 do
		local ent, damage = client_trace_bullet(enemy, ex[i], ey[i], ez[i], x, y, z)
		if damage > bestdamage then
			bent = ent
			bestdamage = damage
		end
	end
	return bent == nil and client_scale_damage(plocal, 1, bestdamage) or bestdamage
end

local function get_nearest_enemy(plocal, enemies)
	local lx, ly, lz = client_eye_position()
	local view_x, view_y, roll = client_camera_angles()

	local bestenemy = nil
    local fov = 180
    for i=1, #enemies do
        local cur_x, cur_y, cur_z = entity_get_prop(enemies[i], "m_vecOrigin")
        local cur_fov = math_abs(normalize_yaw(calc_shit(lx - cur_x, ly - cur_y) - view_y + 180))
        if cur_fov < fov then
			fov = cur_fov
			bestenemy = enemies[i]
		end
	end

	return bestenemy
end

local function is_valid(nn)
	if nn == 0 then
		return false
	end

	if not entity_is_alive(nn) then
		return false
	end

	if entity_is_dormant(nn) then
		return false
	end

	return true
end

local best_value = 180
local flip_value = 90
local bestenemy = nil
local flip_once = false
local function get_best_desync()
    local plocal = entity_get_local_player()

    local lx, ly, lz = client_eye_position()
	local view_x, view_y, roll = client_camera_angles()

	if ui_get(anti_aim[p_state].bodyyaw) == "Switch key" then
		local should_flip = false

		if flip_once and ui_get(switch_k) then
			flip_value = flip_value == 90 and -90 or 90
			flip_once = false
		elseif not ui_get(switch_k) then
			flip_once = true
		end
	end

    local enemies = entity_get_players(true)

    if #enemies == 0 then
		if ui_get(anti_aim[p_state].bodyyaw) == "Opposite" then
			best_value = 180
		elseif ui_get(anti_aim[p_state].bodyyaw) == "Jitter" then
			best_value = 0
		elseif ui_get(anti_aim[p_state].bodyyaw) == "Switch key" then
			best_value = flip_value
		else
			best_value = 90
		end
		return best_value
    end

	bestenemy = is_valid(last_nn) and last_nn or get_nearest_enemy(plocal, enemies)

    if bestenemy ~= nil and entity_is_alive(bestenemy) then
        local calc_hit = last_hit[bestenemy] ~= 0 and contains(anti_aim[p_state].bodyyaw_settings, "Anti-resolver")
        local calc_miss = miss[bestenemy][4] > 0 and contains(anti_aim[p_state].bodyyaw_settings, "Anti-resolver")

		if not calc_hit and not calc_miss then
            local e_x, e_y, e_z = entity_hitbox_position(bestenemy, 0)

            local yaw = calc_angle(lx, ly, e_x, e_y)
            local rdir_x, rdir_y, rdir_z = angle_vector(0, (yaw + 90))
			local rend_x = lx + rdir_x * 10
            local rend_y = ly + rdir_y * 10
            
            local ldir_x, ldir_y, ldir_z = angle_vector(0, (yaw - 90))
			local lend_x = lx + ldir_x * 10
            local lend_y = ly + ldir_y * 10
            
			local r2dir_x, r2dir_y, r2dir_z = angle_vector(0, (yaw + 90))
			local r2end_x = lx + r2dir_x * 100
			local r2end_y = ly + r2dir_y * 100

			local l2dir_x, l2dir_y, l2dir_z = angle_vector(0, (yaw - 90))
			local l2end_x = lx + l2dir_x * 100
            local l2end_y = ly + l2dir_y * 100      
            
			local ldamage = get_damage(plocal, bestenemy, rend_x, rend_y, lz)
			local rdamage = get_damage(plocal, bestenemy, lend_x, lend_y, lz)

			local l2damage = get_damage(plocal, bestenemy, r2end_x, r2end_y, lz)
			local r2damage = get_damage(plocal, bestenemy, l2end_x, l2end_y, lz)

			if ldamage > 0 and rdamage > 0 and contains(anti_aim[p_state].bodyyaw_settings, "Jitter when vulnerable") then
				best_value = 0
			else
				if ui_get(anti_aim[p_state].bodyyaw) == "Opposite" then
					best_value = 180
				elseif ui_get(anti_aim[p_state].bodyyaw) == "Jitter" then
					best_value = 0
				elseif ui_get(anti_aim[p_state].bodyyaw) == "Switch key" then
					best_value = flip_value
				else
					if l2damage > r2damage or ldamage > rdamage then
						best_value = ui_get(anti_aim[p_state].bodyyaw) == "Freestanding" and -90 or 90
					elseif r2damage > l2damage or rdamage > ldamage then
						best_value = ui_get(anti_aim[p_state].bodyyaw) == "Freestanding" and 90 or -90
					end
				end
			end

        elseif calc_hit then
            best_value = last_hit[bestenemy] == 90 and -90 or 90
        elseif calc_miss then
			if stored_misses[bestenemy] ~= miss[bestenemy][4] then
                best_value = miss[bestenemy][2][miss[bestenemy][4]]
                stored_misses[bestenemy] = miss[bestenemy][4]
            end
        end
	else
		if ui_get(anti_aim[p_state].bodyyaw) == "Opposite" then
			best_value = 180
		elseif ui_get(anti_aim[p_state].bodyyaw) == "Jitter" then
			best_value = 0
		elseif ui_get(anti_aim[p_state].bodyyaw) == "Switch key" then
			best_value = flip_value
		else
			best_value = 90
		end
	end
    return best_value
end

local last_press_t = 0
local function run_direction()
	local fs_e = ui_get(freestand_key)
	ui_set(ref_freestand, fs_e and "Default" or "-")

	ui_set(switch_k, "On hotkey")
	ui_set(ref_freestandkey, "Always on")
	ui_set(ref_oskey, "Always on")
	ui_set(manual_back, "On hotkey")
	ui_set(manual_left, "On hotkey")
	ui_set(manual_right, "On hotkey")

	if fs_e or not ui_get(manual_enable) then
		aa_dir = 0
	else
		if ui_get(manual_back) then
			aa_dir = 0
		elseif ui_get(manual_right) and last_press_t + 0.2 < globals_curtime() then
			aa_dir = aa_dir == 90 and 0 or 90
			last_press_t = globals_curtime()
		elseif ui_get(manual_left) and last_press_t + 0.2 < globals_curtime() then
			aa_dir = aa_dir == -90 and 0 or -90
			last_press_t = globals_curtime()
		elseif last_press_t > globals_curtime() then
			last_press_t = globals_curtime()
		end
	end
end

local on_shot_mode = "KEY"
local function run_shit(c)
	local plocal = entity_get_local_player()

	local vx, vy, vz = entity_get_prop(plocal, "m_vecVelocity")

	local p_still = math_sqrt(vx ^ 2 + vy ^ 2) < 2
	local on_ground = bit_band(entity_get_prop(plocal, "m_fFlags"), 1) == 1 and c.in_jump == 0
	local p_slow = ui_get(ref_slow) and ui_get(ref_slowkey)
	local p_key = ui_get(anti_aim[6].enable)

	local wpn = entity_get_player_weapon(plocal)
	local wpn_id = entity_get_prop(wpn, "m_iItemDefinitionIndex")
	local m_item = bit_band(wpn_id, 0xFFFF)

	local onshotaa = false	
	p_state = 1

	if p_key then
		p_state = 6
	else
		if not on_ground and ui_get(anti_aim[5].enable) then
			p_state = 5
		else
			if p_slow and ui_get(anti_aim[4].enable) then
				p_state = 4
			else
				if p_still and ui_get(anti_aim[2].enable) then
					p_state = 2
				elseif not p_still and ui_get(anti_aim[3].enable) then
					p_state = 3
				end
			end
		end
	end

	if not on_ground then
		onshotaa = contains(onshot_aa_settings, "In air")
		on_shot_mode = contains(onshot_aa_settings, "In air") and "IN AIR" or on_shot_mode
	else
		if p_slow then
			onshotaa = contains(onshot_aa_settings, "On slow-mo")
			on_shot_mode = contains(onshot_aa_settings, "On slow-mo") and "SLOW-MO" or on_shot_mode
		else
			if c.in_duck == 1 then		
				onshotaa = contains(onshot_aa_settings, "While crouching")
				on_shot_mode = contains(onshot_aa_settings, "While crouching") and "CROUCHING" or on_shot_mode
			else
				onshotaa = p_still and contains(onshot_aa_settings, "While standing") or contains(onshot_aa_settings, "While moving")
				on_shot_mode = (contains(onshot_aa_settings, "While standing") or contains(onshot_aa_settings, "While moving")) and (p_still and "STANDING" or "MOVING") or on_shot_mode
			end
		end
	end

	if ui_get(onshot_aa_key) then
		on_shot_mode = get_key_mode(onshot_aa_key, 1)
		onshotaa = true
	end

	ui_set(ref_os, onshotaa and m_item ~= 64 and not ui_get(ref.fakeduck))
end

local function distance3d(x1, y1, z1, x2, y2, z2)
	return math.sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) + (z2-z1)*(z2-z1))
end

local classnames = {
	"CWorld",
	"CCSPlayer",
	"CFuncBrush"
}

local function entity_has_c4(ent)
	local bomb = entity.get_all("CC4")[1]
	return bomb ~= nil and entity_get_prop(bomb, "m_hOwnerEntity") == ent
end

local function aa_on_use(c)

	if contains(aa_settings, "Anti-aim on use") then
		local plocal = entity_get_local_player()
		
		local distance = 100
		local bomb = entity_get_all("CPlantedC4")[1]
		local bomb_x, bomb_y, bomb_z = entity_get_prop(bomb, "m_vecOrigin")

		if bomb_x ~= nil then
			local player_x, player_y, player_z = entity_get_prop(plocal, "m_vecOrigin")
			distance = distance3d(bomb_x, bomb_y, bomb_z, player_x, player_y, player_z)
		end
		
		local team_num = entity_get_prop(plocal, "m_iTeamNum")
		local defusing = team_num == 3 and distance < 62

		local on_bombsite = entity_get_prop(plocal, "m_bInBombZone")

		local has_bomb = entity_has_c4(plocal)
		local trynna_plant = on_bombsite ~= 0 and team_num == 2 and has_bomb and not contains(aa_settings, "Disable use to plant")
		
		local px, py, pz = client_eye_position()
		local pitch, yaw = client_camera_angles()
	
		local sin_pitch = math_sin(math_rad(pitch))
		local cos_pitch = math_cos(math_rad(pitch))
		local sin_yaw = math_sin(math_rad(yaw))
		local cos_yaw = math_cos(math_rad(yaw))

		local dir_vec = { cos_pitch * cos_yaw, cos_pitch * sin_yaw, -sin_pitch }

		local fraction, entindex = client_trace_line(plocal, px, py, pz, px + (dir_vec[1] * 8192), py + (dir_vec[2] * 8192), pz + (dir_vec[3] * 8192))

		local using = true

		for i=0, #classnames do
			if entity_get_classname(entindex) == classnames[i] then
				using = false
			end
		end

		if not using and not trynna_plant and not defusing then
			c.in_use = 0
		end
	end
end

local function handle_shots()
	local enemies = entity_get_players(true)

	for i=1, #enemies do
		local idx = enemies[i]
		local s = shots[idx][4]
		local h = hit[idx][4]

		if s ~= stored_shots[idx] then
			local missed = true

			if shots[idx][1][s] == hit[idx][1][h] then
				if hit[idx][2][h] ~= 0 and hit[idx][2][h] ~= 180 then
					last_hit[idx] = hit[idx][2][h]
					last_nn = idx
				end
				missed = false
			end

			if missed then
				last_hit[idx] = 0
				hit[idx][2][h] = 0
				miss[idx][4] = miss[idx][4] + 1
				miss[idx][2][miss[idx][4]] = shots[idx][2][s]
				last_nn = idx
			end

			stored_shots[idx] = s
		end
	end
end

local last_sway_time = 0
local choked_cmds = 0
local function on_setup_command(c)
    if not ui_get(ref.enabled) then
        return
	end

	run_shit(c)
	run_direction()
	handle_shots()
	aa_on_use(c)

	local best_desync = get_best_desync()

	local doubletapping = ui_get(ref_dt) and ui_get(ref_dtkey)
	local onshotaa = ui_get(ref_os) and ui_get(ref_oskey)
	local exploiting = doubletapping or onshotaa

	ui_set(ref.pitch, ui_get(anti_aim[p_state].pitch))
	ui_set(ref.yawbase, aa_dir == 0 and ui_get(anti_aim[p_state].yawbase) or "Local view")
	ui_set(ref_yaw, ui_get(anti_aim[p_state].yaw))
	ui_set(ref_yawadd, normalize_yaw(ui_get(anti_aim[p_state].yawadd) + aa_dir))
	ui_set(ref_yawjitter, ui_get(anti_aim[p_state].yawjitter))
	ui_set(ref_yawjitteradd, ui_get(anti_aim[p_state].yawjitteradd))
	
	local fakelimit = ui_get(anti_aim[p_state].fakeyawlimit)
	local fakemode = ui_get(anti_aim[p_state].fakeyawmode)
	local fakeamt = ui_get(anti_aim[p_state].fakeyawamt)
	local lby = ui_get(anti_aim[p_state].lowerbodyyaw)

	if fakemode == "Jitter" then
		fakelimit = client_random_int(0, 1) == 1 and fakeamt or fakelimit
	elseif fakemode == "Random" then
		fakelimit = client_random_int(math_max(math_min(60, fakelimit - fakeamt), 0), fakelimit)
	elseif fakemode == "Smart" then
		fakelimit = best_desync == 90 and 40 or fakelimit
	end

	ui_set(ref.fakeyawlimit, fakelimit)
	ui_set(ref.edgeyaw, ui_get(anti_aim[p_state].gs_edgeyaw))

	if ui_get(anti_aim[p_state].aa_mode) == "Teamskeet" then
		if ui_get(anti_aim[p_state].bodyyaw) ~= "Off" then
			if best_desync == 0 or best_desync == 180 then
				ui_set(ref_bodyyaw, best_desync == 0 and "Jitter" or "Opposite")
				ui_set(ref_bodyyawadd, 0)
			else
				ui_set(ref_bodyyaw, "Static")
				ui_set(ref_bodyyawadd, best_desync)
			end
		else
			ui_set(ref_bodyyaw, "Off")
		end
	else
		ui_set(ref_bodyyaw, ui_get(anti_aim[p_state].gs_bodyyaw))
		ui_set(ref_bodyyawadd, ui_get(anti_aim[p_state].gs_bodyyawadd))
	end

	--lowerbody
	if lby ~= "Half sway" then
		ui_set(ref.lowerbodyyaw, (lby == "Opposite" and (exploiting or best_desync == 0)) and "Eye yaw" or lby)
	else
		if last_sway_time + 1.1 < globals_curtime() then
			ui_set(ref.lowerbodyyaw, ui_get(ref.lowerbodyyaw) == "Eye yaw" and "Opposite" or "Eye yaw")
			last_sway_time = globals_curtime()
		elseif last_sway_time > globals_curtime() then
			last_sway_time = globals_curtime()
		end
	end

	choked_cmds = c.chokedcommands
	handle_menu()
end

local function is_dragging(x, y, w, h)
	local mx, my = ui_mouse_position()
	local click = client_key_state(0x01)
	
	local in_x = mx > x and mx < x + w	
	local in_y = my > y and my < y + h 

	return in_x and in_y and click and ui_is_menu_open()
end

local function is_dragging_menu()
	local x, y = ui_mouse_position()
	local px, py = ui_menu_position()
	local sx, sy = ui_menu_size()
	local click = client_key_state(0x01)
	
	local in_x = x > px and x < px + sx	
	local in_y = y > py and y < py + sy 

	return in_x and in_y and click and ui_is_menu_open()
end

local ts_time = 0
local clantag_enbl = false
local function run_clantag()
	if contains(ind_set, "Clantag") then
		if ts_time + 0.3 < globals_curtime() then
			client_set_clan_tag(rotate_string())
			ts_time = globals_curtime()
		elseif ts_time > globals_curtime() then
			ts_time = globals_curtime()
		end
		clantag_enbl = true
	elseif not contains(ind_set, "Clantag") and clantag_enbl then
		client_set_clan_tag("")
		clantag_enbl = false
	end
end

local function run_remove_skeet()
	if contains(ind_sli, "Remove skeet indicators") then
		for i=1, 400 do
			renderer_indicator(0, 0, 0, 0, " ")
		end
	end
end

local dragging = false
local ox, oy = 0, 0
local function run_dragging()
	local click = client_key_state(0x01)
	local mx, my = ui_mouse_position()
	local x, y = ui_get(pos_x), ui_get(pos_y)
	local sx, sy = client_screen_size()

	if dragging then
		local dx, dy = x - ox, y - oy
		ui_set(pos_x, math_min(math_max(mx + dx, 0), sx))
		ui_set(pos_y, math_min(math_max(my + dy, 0), sy))
		ox, oy = mx, my
	else
		ox, oy = mx, my
	end
end

local function get_sliders(plocal)
	local arr = {}

	local desync = entity_get_prop(plocal, "m_flPoseParameter", 11) * 116 - 58
	local v = vector(entity_get_prop(plocal, "m_vecVelocity"))
	local speed = v:length2d()

	if contains(ind_sli, "Desync") and ui_get(ref.enabled) then
		arr[#arr + 1] = {
			v = round(desync, 0),
			p = math_abs(desync / 58),
			t = "FAKE YAW",
		}
	end

	if contains(ind_sli, "Fake lag") then
		arr[#arr + 1] = {
			v = choked_cmds,
			p = choked_cmds / (ui_get(ref.maxprocticks) - 2),
			t = "FAKE LAG"
		}
	end

	if contains(ind_sli, "Speed") then
		arr[#arr + 1] = {
			v = round(speed),
			p = speed / 250,
			t = "VELOCITY"
		}
	end
	return arr
end

local function get_keys()
	local arr = {}

	if ui_get(ref.fakeduck) then
		arr[#arr + 1] = {
			t = "FAKE DUCK",
			v = get_key_mode(ref.fakeduck, 1)
		}
	end
	
	if ui_get(anti_aim[6].enable) then
		arr[#arr + 1] = {
			t = "ON-KEY AA",
			v = get_key_mode(anti_aim[6].enable, 1)
		}
	end
	
	if ui_get(ref_os) and ui_get(ref_oskey) then
		arr[#arr + 1] = {
			t = "HIDE SHOTS",
			v = on_shot_mode
		}
	end
	
	if ui_get(ref_dt) and ui_get(ref_dtkey) then
		arr[#arr + 1] = {
			t = "DOUBLE TAP",
			v = get_key_mode(ref_dtkey, 1)
		}
	end
	
	if ui_get(ref.safepoint) then
		arr[#arr + 1] = {
			t = "SAFE POINT",
			v = get_key_mode(ref.safepoint, 1)
		}
	end

	if ui_get(ref.forcebaim) then
		arr[#arr + 1] = {
			t = "FORCE BAIM",
			v = get_key_mode(ref.forcebaim, 1)
		}
	end
	
	if ui_get(freestand_key) then
		arr[#arr + 1] = {
			t = "FREESTANDING",
			v = get_key_mode(freestand_key, 1)
		}
	end
	
	if ui_get(ref_ps) and ui_get(ref_pskey) then
		arr[#arr + 1] = {
			t = "PING SPIKE",
			v = get_key_mode(ref_pskey, 1)
		}
	end

	if ui_get(ref_quickpeek) and ui_get(ref_quickpeekkey) then
		arr[#arr + 1] = {
			t = "QUICK PEEK",
			v = get_key_mode(ref_quickpeekkey, 1)
		}
	end
	
	for i=1, #custom_keys do
		if ui_get(custom_keys[i].ref) then
			arr[#arr + 1] = {
				t = custom_keys[i].name,
				v = get_key_mode(custom_keys[i].ref, 1)
			}
		end
	end

	return arr
end

local hypno_width = 27
local function on_paint()
	local plocal = entity_get_local_player()

	run_clantag()
	run_remove_skeet()

	if not entity_is_alive(plocal) then
		return
	end

	local click = client_key_state(0x01)
	local sx, sy = client_screen_size()
	local cx, cy = sx / 2, sy / 2 - 2
	local r, g, b, a = ui_get(ind_clr)
	local r1, g1, b1, a1 = ui_get(ind_clr2)

	local x, y = ui_get(pos_x), ui_get(pos_y)

	local sliders, keys = {}, {}
	local scale = contains(ind_sli, "Big") and 1.5 or 1
	local w, h = 200 * scale, 20 * scale		
	local i_dist = scale == 1 and 16 or 18 

	if contains(ind_set, "Indicators") then

		sliders = get_sliders(plocal)

		renderer_rectangle(x, y, w, h, 20, 20, 20, 255)
		renderer_text(x + w/2, y + i_dist/2, 255, 255, 255, 255, scale == 1 and "-c" or "cb", nil, "INDICATORS")	
		
        if contains(ind_sli, "Gradient") then
            renderer_gradient(x, y, w/2, scale^2, 0, 200, 255, 255, 255, 0, 255, 255, true)
            renderer_gradient(x + w/2, y, w/2, scale^2, 255, 0, 255, 255, 175, 255, 0, 255, true)
        else
			renderer_rectangle(x, y, w, scale^2, r, g, b, a)
			renderer_rectangle(x, y, w, scale^2, r, g, b, a)
		end

		local m_h = (#sliders * i_dist)

		renderer_rectangle(x, y+i_dist, w, m_h, 25, 25, 25, 255)
		renderer_rectangle(x, y+i_dist + m_h, w, 5, 20, 20, 20, 255)

		for i=1, #sliders do
            renderer_text(x + 5, y + ((i + 1) * i_dist) - 15, 255, 255, 255, 255, scale == 1 and "-" or "b", nil, sliders[i].t)

			local stx = x + math_floor(w/4.5) - 1
			local sty = y + ((i + 1) * i_dist) - 14
			local m_w = math_floor(w/1.33) + (scale == 1 and 0 or 1)
			local height = scale == 1 and h/2.25 or h/2.75

			if contains(ind_sli, "Show values") then
				stx = x + math_floor(w/3.25)
				sty = y + ((i + 1) * i_dist) - 14
				m_w = math_floor(w/1.5)
				renderer_text(x + math_floor(w/4.5), y + ((i + 1) * i_dist) - 15, 255, 255, 255, 255, scale == 1 and "-" or "", nil, sliders[i].v)
			end

			local width = math_max(math_min(m_w, m_w * sliders[i].p), 5)

			if contains(ind_sli, "Gradient") then
				renderer_gradient(stx, sty, math_floor(m_w/2), height, 0, 200, 255, 255, 255, 0, 255, 255, true)
				renderer_gradient(stx + math_floor(m_w/2), sty, math_floor(m_w/2), height, 255, 0, 255, 255, 175, 255, 0, 255, true)
				renderer_rectangle(stx + 1, sty + 1, m_w - 2, height - 2, 25, 25, 25, 150)

				local amt = m_w - width
				if amt > 0 then
					renderer_rectangle(x + w - 5 - amt, sty, amt, height, 25, 25, 25, 255)
				end
			else
				renderer_rectangle(stx, sty, width, height, r, g, b, a)
				renderer_rectangle(stx + 1, sty + 1, width - 2, height - 2, 25, 25, 25, 150)
			end
		end
		
		if is_dragging(x, y, w, h + m_h) and not is_dragging_menu() then
			dragging = true
		elseif not click then
			dragging = false
		end
	end

	if contains(ind_set, "Key states") then
		local x2, y2 = x, y + h + (#sliders * i_dist) + 5

		renderer_rectangle(x2, y2, w, h, 20, 20, 20, 255)
		renderer_text(x2 + w/2, y2 + i_dist/2, 255, 255, 255, 255, scale == 1 and "-c" or "cb", nil, "KEYBINDS")
		
		if contains(ind_sli, "Gradient") then
            renderer_gradient(x2, y2, w/2, scale^2, 0, 200, 255, 255, 255, 0, 255, 255, true)
            renderer_gradient(x2 + w/2, y2, w/2, scale^2, 255, 0, 255, 255, 175, 255, 0, 255, true)
        else
			renderer_rectangle(x2, y2, w, scale^2, r, g, b, a)
			renderer_rectangle(x2, y2, w, scale^2, r, g, b, a)
		end

		keys = get_keys()

        renderer_rectangle(x2, y2 + i_dist, w, #keys * i_dist + (4 * scale^2), 25, 25, 25, 255)

		for i=1, #keys do
			local tw, th = renderer_measure_text(scale == 1 and "-" or "b", keys[i].v)
			local cur_pos = y2 + ((i + 1) * i_dist) - 13
			if contains(ind_sli, "Gradient") then
				renderer_text(x2 + 5, cur_pos, 100, 200, 255, 255,  scale == 1 and "-" or "b", nil, keys[i].t)
				renderer_text(x2 + w - 10 - tw, cur_pos, 175, 255, 0, 255, scale == 1 and "-" or "b", nil, keys[i].v)
			else
				renderer_text(x2 + 5, cur_pos, r, g, b, a, scale == 1 and "-" or "b", nil, keys[i].t)
				renderer_text(x2 + w - 10 - tw, cur_pos, 255, 255, 255, 255, scale == 1 and "-" or "b", nil, keys[i].v)
			end
		end
				
		if is_dragging(x2, y2, w, (#keys * i_dist) + h) and not is_dragging_menu() then
			dragging = true
		elseif not click then
			dragging = false
		end
	end

	if contains(ind_set, "Anti-aim") then	
		local cam = vector(client_camera_angles())

		local h = vector(entity_hitbox_position(plocal, "head_0"))
		local p = vector(entity_hitbox_position(plocal, "pelvis"))
	
		local yaw = normalize_yaw(calc_angle(p.x, p.y, h.x, h.y) - cam.y + 120)
		local bodyyaw = entity_get_prop(plocal, "m_flPoseParameter", 11)
	
		bodyyaw = bodyyaw * 120 - 60
	
		local fakeangle = normalize_yaw(yaw + bodyyaw)

		if ui_get(aa_ind_type) == "Circle" then	
			renderer_circle_outline(cx, cy + 1, 100, 100, 100, 100, 30, 0, 1, 4)
			renderer_circle_outline(cx, cy + 1, r, g, b, a, 30, (fakeangle * -1) - 15, 0.1, 4)
			renderer_circle_outline(cx, cy + 1, r1, g1, b1, a1, 30, (yaw * -1) - 15, 0.1, 4)
		elseif ui_get(aa_ind_type) == "Arrows" then	
			renderer_arrow(cx, cy, r, g, b, a, (yaw - 25) * -1, 45)
			renderer_arrow(cx, cy, r1, g1, b1, a1, (fakeangle - 25) * -1, 25)
		else
			renderer_triangle(cx + 55, cy + 2, cx + 42, cy - 7, cx + 42, cy + 11, 
			aa_dir == 90 and r or 35, 
			aa_dir == 90 and g or 35, 
			aa_dir == 90 and b or 35, 
			aa_dir == 90 and a or 150)

			renderer_triangle(cx - 55, cy + 2, cx - 42, cy - 7, cx - 42, cy + 11, 
			aa_dir == -90 and r or 35, 
			aa_dir == -90 and g or 35, 
			aa_dir == -90 and b or 35, 
			aa_dir == -90 and a or 150)
			
			renderer_rectangle(cx + 38, cy - 7, 2, 18, 
			bodyyaw < -10 and r1 or 35,
			bodyyaw < -10 and g1 or 35,
			bodyyaw < -10 and b1 or 35,
			bodyyaw < -10 and a1 or 150)
			renderer_rectangle(cx - 40, cy - 7, 2, 18,			
			bodyyaw > 10 and r1 or 35,
			bodyyaw > 10 and g1 or 35,
			bodyyaw > 10 and b1 or 35,
			bodyyaw > 10 and a1 or 150)
		end
	end

	run_dragging(dragging)
end

local function dist_from_3dline(shooter, e)
	local x, y, z = entity_hitbox_position(shooter, 0)
	local x1, y1, z1 = client_eye_position()

	return ((e.y - y)*x1 - (e.x - x)*y1 + e.x*y - e.y*x) / math_sqrt((e.y-y)^2 + (e.x - x)^2)
end

local function on_bullet_impact(e)
	local plocal = entity_get_local_player()
	local shooter = client_userid_to_entindex(e.userid)

	if not entity_is_enemy(shooter) or not entity_is_alive(plocal) then
		return
	end

	local d = dist_from_3dline(shooter, e)

	if math_abs(d) < 100 then
		local dsy = ui_get(ref_bodyyawadd)

		local previous_record = shots[shooter][1][shots[shooter][4]] == globals_curtime()
		shots[shooter][4] = previous_record and shots[shooter][4] or shots[shooter][4] + 1

		shots[shooter][1][shots[shooter][4]] = globals_curtime()

		local dtc = contains(anti_aim[p_state].bodyyaw_settings, "Detect missed angle") or dsy == 0 or dsy == 180

		if dtc then
			shots[shooter][2][shots[shooter][4]] = math_abs(d) > 0.5 and (d < 0 and 90 or -90) or dsy
		else
			shots[shooter][2][shots[shooter][4]] = (dsy == 90 and -90 or 90)
		end
	end
end

local nonweapons = 
{
	"knife",
	"hegrenade",
	"inferno",
	"flashbang",
	"decoy",
	"smokegrenade",
	"taser"
}

local function on_player_hurt(e)
	local plocal = entity_get_local_player()
	local victim = client_userid_to_entindex(e.userid)
	local attacker = client_userid_to_entindex(e.attacker)
	local hitgroup = e.hitgroup

	if not entity_is_enemy(attacker) or not entity_is_alive(plocal) or entity_is_enemy(victim) then
		return
	end

	for i=1, #nonweapons do
		if e.weapon == nonweapons[i] then
			return
		end
	end

	hit[attacker][4] = hit[attacker][4] + 1
	hit[attacker][1][hit[attacker][4]] = globals_curtime()
	hit[attacker][2][hit[attacker][4]] = victim ~= plocal and 0 or ui_get(ref_bodyyawadd)
	hit[attacker][3][hit[attacker][4]] = e.hitgroup
end

local function reset_data(keep_hit)
	for i=1, 64 do
		last_hit[i], stored_misses[i], stored_shots[i] = (keep_hit and hit[i][2][hit[i][4]] ~= 0) and hit[i][2][hit[i][4]] or 0, 0, 0
		for k=1, 3 do
			for j=1, 1000 do
				miss[i][k][j], hit[i][k][j], shots[i][k][j] = 0, 0, 0
			end
		end
		miss[i][4], hit[i][4], shots[i][4], last_nn, best_value = 0, 0, 0, 0, 180
	end
end

local function load_cfg(input)
	local tbl = str_to_sub(input, "|")

	for i=1, 6 do
		ui_set(anti_aim[i].enable, to_boolean(tbl[1 + (16 * (i - 1))]))
		ui_set(anti_aim[i].pitch, tbl[2 + (16 * (i - 1))])
		ui_set(anti_aim[i].yawbase, tbl[3 + (16 * (i - 1))])
		ui_set(anti_aim[i].yaw, tbl[4 + (16 * (i - 1))])
		ui_set(anti_aim[i].yawadd, tonumber(tbl[5 + (16 * (i - 1))]))
		ui_set(anti_aim[i].yawjitter, tbl[6 + (16 * (i - 1))])
		ui_set(anti_aim[i].yawjitteradd, tonumber(tbl[7 + (16 * (i - 1))]))
		ui_set(anti_aim[i].aa_mode, tbl[8 + (16 * (i - 1))])
		ui_set(anti_aim[i].bodyyaw, tbl[9 + (16 * (i - 1))])
		ui_set(anti_aim[i].bodyyaw_settings, str_to_sub(tbl[10 + (16 * (i - 1))], ","))	
		ui_set(anti_aim[i].lowerbodyyaw, tbl[11 + (16 * (i - 1))])
		ui_set(anti_aim[i].fakeyawlimit, tonumber(tbl[12 + (16 * (i - 1))]))
		ui_set(anti_aim[i].fakeyawmode, tbl[13 + (16 * (i - 1))])
		ui_set(anti_aim[i].fakeyawamt, tonumber(tbl[14 + (16 * (i - 1))]))
		ui_set(anti_aim[i].gs_bodyyaw, tbl[15 + (16 * (i - 1))])
		ui_set(anti_aim[i].gs_bodyyawadd, tonumber(tbl[16 + (16 * (i - 1))]))
	end

	ui_set(manual_enable, to_boolean(tbl[97]))
	ui_set(onshot_aa_settings, str_to_sub(tbl[98], ","))
	ui_set(ind_set, str_to_sub(tbl[99], ","))
	ui_set(ind_sli, str_to_sub(tbl[100], ","))
	ui_set(aa_ind_type, tbl[101])
	ui_set(aa_settings, str_to_sub(tbl[102], ","))

	client_log("Loaded config from clipboard")
end

local function export_cfg()
	local str = ""

	for i=1, 6 do
		local get_key = i == 6 and get_key_mode or ui_get

		str = str .. tostring(get_key(anti_aim[i].enable)) .. "|"
		.. tostring(ui_get(anti_aim[i].pitch)) .. "|"
		.. tostring(ui_get(anti_aim[i].yawbase)) .. "|"
		.. tostring(ui_get(anti_aim[i].yaw)) .. "|"
		.. tostring(ui_get(anti_aim[i].yawadd)) .. "|"
		.. tostring(ui_get(anti_aim[i].yawjitter)) .. "|"
		.. tostring(ui_get(anti_aim[i].yawjitteradd)) .. "|"
		.. tostring(ui_get(anti_aim[i].aa_mode)) .. "|"
		.. tostring(ui_get(anti_aim[i].bodyyaw)) .. "|"
		.. arr_to_string(anti_aim[i].bodyyaw_settings) .. "|"
		.. tostring(ui_get(anti_aim[i].lowerbodyyaw)) .. "|"
		.. tostring(ui_get(anti_aim[i].fakeyawlimit)) .. "|"
		.. tostring(ui_get(anti_aim[i].fakeyawmode)) .. "|"
		.. tostring(ui_get(anti_aim[i].fakeyawamt)) .. "|"
		.. tostring(ui_get(anti_aim[i].gs_bodyyaw)) .. "|"
		.. tostring(ui_get(anti_aim[i].gs_bodyyawadd)) .. "|"
	end

	str = str .. tostring(ui_get(manual_enable)) .. "|"
	.. arr_to_string(onshot_aa_settings) .. "|"
	.. arr_to_string(ind_set) .. "|"
	.. arr_to_string(ind_sli) .. "|"
	.. tostring(ui_get(aa_ind_type)) .. "|"
	.. arr_to_string(aa_settings)

	clipboard_export(str)
	client_log("Exported config to clipboard")
end

local function add_custom_key(input)
	local str = string.gsub(input, "//add_keybind ", "")

	local subs = str_to_sub(str, ",")

	local ref1, ref2 = nil, nil
	local got_reference = pcall(function() ref1, ref2 = ui.reference(subs[1], subs[2], subs[3]) end)

	if got_reference and #subs == 4 then
		local hotkey_ref = ref2 == nil and ref1 or ref2

		custom_keys[#custom_keys + 1] = {
			ref = hotkey_ref,
			name = subs[4]
		}

		custom_key_saves[#custom_key_saves + 1] = str
		client.log("Succesfully added " .. subs[4] .. " to the keybinds list!")
	else
		if got_reference then
			client.log("You forgot to add the name of the key you fucking retard")
		else
			client.log("Failed to add the key :( Couldn't find it in the menu")
		end	
	end
end

local function on_console_input(input)
	if string_find(input, "//load kace") then
		client_log("Config loaded!")
		--global
		ui_set(anti_aim[1].pitch, "Default")
		ui_set(anti_aim[1].yawbase, "At targets")
		ui_set(anti_aim[1].yaw, "180")
		ui_set(anti_aim[1].yawadd, 0)
		ui_set(anti_aim[1].yawjitter, "Off")
		ui_set(anti_aim[1].yawjitteradd, 0)
		ui_set(anti_aim[1].aa_mode, "Teamskeet")
		ui_set(anti_aim[1].bodyyaw, "Reversed freestanding")
		ui_set(anti_aim[1].bodyyaw_settings, {"Anti-resolver", "Jitter when vulnerable"})
		ui_set(anti_aim[1].lowerbodyyaw, "Opposite")
		ui_set(anti_aim[1].fakeyawlimit, 60)
		ui_set(anti_aim[1].fakeyawmode, "Custom right")
		ui_set(anti_aim[1].fakeyawamt, 35)
		--air
		ui_set(anti_aim[5].enable, true)
		ui_set(anti_aim[5].pitch, "Default")
		ui_set(anti_aim[5].yawbase, "At targets")
		ui_set(anti_aim[5].yaw, "180")
		ui_set(anti_aim[5].yawadd, 0)
		ui_set(anti_aim[5].yawjitter, "Off")
		ui_set(anti_aim[5].yawjitteradd, 0)
		ui_set(anti_aim[5].aa_mode, "Teamskeet")
		ui_set(anti_aim[5].bodyyaw, "Opposite")
		ui_set(anti_aim[5].bodyyaw_settings, {"Anti-resolver"})
		ui_set(anti_aim[5].lowerbodyyaw, "Opposite")
		ui_set(anti_aim[5].fakeyawlimit, 60)
		ui_set(anti_aim[5].fakeyawmode, "Off")

		for i=2, 4 do
			ui_set(anti_aim[i].enable, false)
		end

		ui_set(manual_enable, true)
		ui_set(onshot_aa_key, "Toggle")
		ui_set(onshot_aa_settings, {"On slow-mo", "While crouching", "On key"})
		ui_set(ind_set, {"Indicators", "Anti-aim", "Key states"})
		ui_set(ind_sli, {"Desync", "Fake lag", "Speed", "Gradient"})
		ui_set(aa_ind_type, "Arrows")
	elseif string_find(input, "//load sigma") then
		client_log("Config loaded!")
		--global
		ui_set(anti_aim[1].pitch, "Default")
		ui_set(anti_aim[1].yawbase, "At targets")
		ui_set(anti_aim[1].yaw, "180")
		ui_set(anti_aim[1].yawadd, 0)
		ui_set(anti_aim[1].yawjitter, "Off")
		ui_set(anti_aim[1].yawjitteradd, 0)
		ui_set(anti_aim[1].aa_mode, "Teamskeet")
		ui_set(anti_aim[1].bodyyaw, "Reversed freestanding")
		ui_set(anti_aim[1].bodyyaw_settings, {"Anti-resolver", "Jitter when vulnerable"})
		ui_set(anti_aim[1].lowerbodyyaw, "Eye yaw")
		ui_set(anti_aim[1].fakeyawlimit, 60)
		ui_set(anti_aim[1].fakeyawmode, "Off")

		for i=2, 5 do
			ui_set(anti_aim[i].enable, false)
		end
		
		ui_set(manual_enable, true)
		ui_set(onshot_aa_key, "Toggle")
		ui_set(onshot_aa_settings, {"On key"})
		ui_set(ind_set, {"Indicators", "Anti-aim", "Key states"})
		ui_set(ind_sli, {"Desync", "Fake lag", "Speed", "Gradient"})
		ui_set(aa_ind_type, "Static")
	elseif string_find(input, "//help") then
		client_color_log(255, 255, 255, "|--------------------------------------------------------|")
		client_color_log(0, 150, 255, 	"[//load kace] Load Kace's AA settings")
		client_color_log(150, 0, 200,   "[//load sigma] Load Sigma's AA settings")
		client_color_log(225, 0, 225, 	"[//export] Export your anti-aim settings to your clipboard")
		client_color_log(255, 150, 175, "[//import] Import anti-aim settings from your clipboard")
		client_color_log(255, 150, 150, "[//add_keybind TAB,CONTAINER,ELEMENT,INDICATOR NAME] Add a custom keybind to the keybind indicator")
		client_color_log(255, 200, 60,  "[//keybinds] Lists the stored keybinds")
		client_color_log(230, 255, 60,  "[//remove_keybind #] Removes the selected keybind")
		client_color_log(175, 255, 0, 	"[//help] Print a list of commands")
		client_color_log(255, 255, 255, "|--------------------------------------------------------|")
		client_color_log()
	elseif string_find(input, "//export") then
		export_cfg()
	elseif string_find(input, "//import") then
		load_cfg(clipboard_import())
	elseif string_find(input, "//add_keybind") then
		add_custom_key(input)
	elseif string_find(input, "//keybinds") then
		for i=1, #custom_key_saves do
			local subs = str_to_sub(custom_key_saves[i], ",")
			client.log(i .. " - " .. subs[4])
		end
	elseif string_find(input, "//remove_keybind") then
		local t_str = string.gsub(input, "//remove_keybind ", "")

		local num = tonumber(t_str)
		local subs = str_to_sub(custom_key_saves[num], ",")

		if #custom_keys >= num and custom_keys[num].name == subs[4] then
			table.remove(custom_keys, num)
		end
		
		table.remove(custom_key_saves, num)
		database.write("ts_custom_keys", custom_key_saves)

		client.log("Succesfuly removed " .. tostring(subs[4]) .. " from the stored keybinds!")
	end
end

local function handle_callbacks()
	client.exec("clear")
	client_color_log(255, 255, 255, "|--------------------------------------------------------|")
	client_color_log(0, 150, 255, 	"           Thanks for downloading Teamskeet V2!           ")
	client_color_log(150, 0, 200,   "            Type //help for a list of commands            ")
	client_color_log(225, 0, 225, 	"   Support the script: https://patreon.com/luascripting   ")
	client_color_log(255, 150, 175, "   For the best skeet configs: https://shoppy.gg/@amgis   ")
	client_color_log(175, 255, 0, 	" Join the discord for updates: https://discord.gg/eQj9fEe ")
	client_color_log(255, 255, 255, "|--------------------------------------------------------|")
    ui_set_callback(player_state, handle_menu)
	ui_set_callback(manual_enable, handle_menu)
	ui_set_callback(ind_set, handle_menu)
	for i=1, 6 do
		ui_set_callback(anti_aim[i].aa_mode, handle_menu)
		ui_set_callback(anti_aim[i].yaw, handle_menu)
		ui_set_callback(anti_aim[i].yawadd, handle_menu)
		ui_set_callback(anti_aim[i].bodyyaw, handle_menu)
        ui_set_callback(anti_aim[i].yawjitter, handle_menu)
        ui_set_callback(anti_aim[i].fakeyawmode, handle_menu)
	end

	local stored = database.read("ts_custom_keys")

	if stored ~= nil then
		custom_key_saves = database.read("ts_custom_keys")
	end

	for i=1, #custom_key_saves do
		local subs = str_to_sub(custom_key_saves[i], ",")

		local nigger = nil
		if pcall(function() nigger = ui_reference(subs[1], subs[2], subs[3]) end) then
			custom_keys[i] = {
				ref = nigger,
				name = subs[4]
			}
		else
			client.log(subs[4] .. " not found!")
		end
	end
	
    client_set_event_callback("shutdown", function()
		set_og_menu(true)
		database.write("ts_custom_keys", custom_key_saves)
	end)

	client_set_event_callback("player_death", function(e)
		if client_userid_to_entindex(e.userid) == entity_get_local_player() then
			reset_data(true)
		end
	end)

	client_set_event_callback("round_start", function()
		reset_data(true)
	end)

	client_set_event_callback("client_disconnect", function()
		reset_data(false)
	end)

	client_set_event_callback("game_newmap", function()
		reset_data(false)
	end)

	client_set_event_callback("cs_game_disconnected", function()
		reset_data(false)
	end)
	
	client_set_event_callback("bullet_impact", on_bullet_impact)
	client_set_event_callback("player_hurt", on_player_hurt)
	client_set_event_callback("console_input", on_console_input)
	client_set_event_callback("setup_command", on_setup_command)
    client_set_event_callback("paint", on_paint)
end
handle_callbacks()