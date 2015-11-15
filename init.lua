local path = minetest.get_modpath(minetest.get_current_modname())

dofile(path .. "/chatcommands.lua")

langton_ant = {}

langton_ant.white = {name = "wool:white"}
langton_ant.black = {name = "wool:black"}

langton_ant.timer = 0
langton_ant.step_timer = 0.1

langton_ant.max_iterations = -1

langton_ant.ants = {}

langton_ant.register_new_ant = function(player)
	-- Normalize player location
	local pos = player:getpos()
	local yaw = player:getyaw()

	math.floor(pos.x)
	math.floor(15.0)
	math.floor(pos.z)
	yaw = 0.0

	player:setpos(pos)
	player:setyaw(yaw)

	langton_ant.ants[player:get_player_name()] = {direction = {x=0,y=1,z=0,yaw=0}, player = player, iteration = 0}
end

langton_ant.update_ant = function(ant)
	local pos = ant.player:getpos()
	local node_pos = pos

	node_pos.y = node_pos.y - 1

	local node = minetest.get_node(node_pos)
	local name = node.name
	local dir = ant.direction

	if name ~= langton_ant.black.name then
		minetest.set_node(node_pos,langton_ant.black)
		dir.yaw = dir.yaw - math.pi/2
	else
		minetest.set_node(node_pos,langton_ant.white)
		dir.yaw = dir.yaw + math.pi/2
	end

	dir.x = math.cos(dir.yaw)
	dir.z = math.sin(dir.yaw)

	pos.x = pos.x + dir.x
	pos.y = pos.y + dir.y
	pos.z = pos.z + dir.z

	ant.player:setpos(pos)
	ant.iteration = ant.iteration + 1

	if ant.iteration == langton_ant.max_iterations then
		langton_ant.unregister_ant(ant.player)
	end

	if ant.iteration % 500 == 0 then
		minetest.chat_send_player(ant.player:get_player_name(),"Iteration count: " .. ant.iteration)
	end
end

langton_ant.unregister_ant = function(player)
	langton_ant.ants[player:get_player_name()] = nil
end

langton_ant.setvar = function(name,value) 
	if name == "step_timer" then
		langton_ant.step_timer = tonumber(value)
	end

	if name == "max_iterations" then
		langton_ant.max_iterations = tonumber(value)
	end
end

minetest.register_globalstep(function(dt)
	langton_ant.timer = langton_ant.timer + dt

	if langton_ant.timer >= langton_ant.step_timer then
		for key,val in pairs(langton_ant.ants) do
			langton_ant.update_ant(val)
		end
		langton_ant.timer = 0
	end
end)
