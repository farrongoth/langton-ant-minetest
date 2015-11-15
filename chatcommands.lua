minetest.register_privilege("langton_ant","Can use langton_ant commands");
minetest.register_privilege("langton_ant_global","Can use langton_ant commands");

minetest.register_chatcommand("lant_start", {
	params = "",
	description = "Start langton_ant process",
	privs = {langton_ant=true},
	func = function(name,params)
		local player = minetest.get_player_by_name(name)

		if not player then
			return false, "Player not found"
		end

		langton_ant.register_new_ant(player)
	end
})

minetest.register_chatcommand("lant_stop", {
	params = "",
	description = "Stop langton_ant process",
	privs = {langton_ant=true},
	func = function(name,params)
		local player = minetest.get_player_by_name(name)

		if not player then
			return false, "Player not found"
		end
		langton_ant.unregister_ant(player)
	end
})

minetest.register_chatcommand("lant_set", {
	params = "",
	description = "",
	privs = {langton_ant_global=true},
	func = function(name,params)
		local name,value = string.match(params,"([^ ]+) (.+)")
		if name and value then
			langton_ant.setvar(name,value)
		end
	end
})
