local timer = 0
local step_timer = 0.25
local direction = {x=0,y=0,z=0,yaw=0}
local player_joined = false

minetest.register_on_joinplayer(function(player)
	player_joined = true
end)

minetest.register_globalstep(function(dt)
	if not player_joined then return end

	timer = timer + dt
	if timer >= step_timer then
		local player = minetest.get_player_by_name('singleplayer')
		local pos = player:getpos()

		local node_pos = {}
		node_pos.x = pos.x
		node_pos.y = pos.y - 1
		node_pos.z = pos.z

		local node = minetest.get_node(node_pos)
		local name = node.name

		if name ~= "wool:white" then
			minetest.set_node(node_pos,{name="wool:white"})
			direction.yaw = direction.yaw - math.pi/2
		else
			minetest.set_node(node_pos,{name="wool:black"})
			direction.yaw = direction.yaw + math.pi/2
		end

		direction.x = math.cos(direction.yaw)
		direction.z = math.sin(direction.yaw)

		pos.x = pos.x + direction.x
		pos.y = pos.y + direction.y
		pos.z = pos.z + direction.z
		player:setpos(pos)
		timer = 0
	end
end)
