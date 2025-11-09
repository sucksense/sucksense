local get = ui.get
local console_log = client.log

local ui_new_multiselect = ui.new_multiselect

local get_entity_prop = entity.get_prop
local get_player_name = entity.get_player_name
local get_local_player = entity.get_local_player
local set_cvar = client.set_cvar
local set_event_callback = client.set_event_callback
local userid_to_entindex = client.userid_to_entindex

local con_filter_text  = "[gamesense]"
local team_t = 2
local team_ct = 3
local length_tolerance = 24

local _log = ui_new_multiselect("Misc", "Miscellaneous", "Advanced buy logs", "Team", "Enemies")
local purchases = ui_new_multiselect("Misc", "Miscellaneous", "Log purchases", "Pistols", "Guns", "Grenades", "Armor")

local function table_contains(func, val)
	for i=1, #func do
		if func[i] == val then
			return true
		end
	end
	return false
end

local function is_armor(current)
	if current == "assaultsuit" or current == "kevlar" or current == "defuser" then
		return true
	end		
	
	return false
end

local function is_pistol(current)
	if current == "glock" or current == "elite" or current == "p250" or current == "cz75a" or current == "revolver" or current == "deagle" or current == "usp_silencer" or current == "hpk2000" or current == "fiveseven" or current == "tec9" then
		return true
	end		
	
	return false
end

local function is_grenade(current)
	if current == "hegrenade" or current == "smokegrenade" or current == "incgrenade" or current == "decoy" or current == "flashbang" or current == "molotov" then
		return true
	end
	
	return false
end

local function is_gun(current)
	if not is_grenade(current) and not is_pistol(current) and not is_armor(current) then
		return true
	end
	
	return false
end

function on_item_purchase(e)

	local userid = e.userid
	if not userid then return end
	
	local userid_team = e.team
	local userid_entindex = userid_to_entindex(userid)
	if userid_entindex == get_local_player() then return end
	
	local get_teams = get(_log)
	local team_selected = table_contains(get_teams, "Team")
	local enemies_selected = table_contains(get_teams, "Enemies")
	local no_teams_selected = not team_selected and not enemies_selected
	if no_teams_selected then return end
	
	local localplayer_team = get_entity_prop(get_local_player(), "m_iTeamNum") 		
	if userid_team == localplayer_team and not team_selected then return end
	if userid_team ~= localplayer_team and not enemies_selected then return end
	
	local get_log = get(purchases)
	local pistols_selected = table_contains(get_log, "Pistols")
	local guns_selected = table_contains(get_log, "Guns")
	local grenades_selected = table_contains(get_log, "Grenades")
	local armor_selected = table_contains(get_log, "Armor")
	
	local nothing_is_enabled = not pistols_selected and not guns_selected and not grenades_selected and not armor_selected
	if nothing_is_enabled then return end
	
	local weapon = e.weapon
	weapon = weapon:gsub("weapon_", "")
	weapon = weapon:gsub("item_", "")
	if weapon == "unknown" then return end
	
	if is_pistol(weapon) and not pistols_selected then return end
	if is_gun(weapon) and not guns_selected then return end
	if is_grenade(weapon) and not grenades_selected then return end
	if is_armor(weapon) and not armor_selected then return end

	local target_name = get_player_name(userid_entindex)
	target_name = target_name:lower()
	target_name = string.sub(target_name, 1, length_tolerance)
	
	if weapon == 'assaultsuit' then
		weapon = 'kelvar and helmet'
	elseif weapon == 'incgrenade' then
		weapon = 'incendiary'
	end
	
	local team = ""
	if userid_team == team_t then
		team = "t"
	elseif userid_team == team_ct then
		team = "ct"
	end
		
	console_log("[", team, "] ", target_name, " purchased ", weapon, ".")
end	

set_event_callback("item_purchase", on_item_purchase)
set_cvar('developer', 1)
set_cvar('con_filter_enable', 1)
set_cvar('con_filter_text', con_filter_text)