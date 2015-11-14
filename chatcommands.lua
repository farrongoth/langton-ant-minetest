minetest.register_chatcommand("lant_start", {
	params = "",
	description = "Start langton_ant process",
	privs = {},
	func = function(name,params)
		if started then return end

		local player = minetest.get_player_by_name(name)

		if not player then
			return false, "Player not found"
		end

		local pos = player:getpos()
		local yaw = player:getyaw()

		pos.x = math.floor(pos.x)
		pos.y = math.floor(25.0) -- Height
		pos.z = math.floor(pos.z)
		yaw = 0.0

		player:setpos(pos)
		player:setyaw(yaw)

		started = true
	end
})

minetest.register_chatcommand("lant_stop", {
	params = "",
	description = "Stop langton_ant process",
	privs = {},
	func = function(name,params)
		if not started then return end
		local player = minetest.get_player_by_name(name)

		if not player then
			return false, "Player not found"
		end

		started = false
	end
})
