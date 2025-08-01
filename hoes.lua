
-- translation and mod check

local S = core.get_translator("farming")
local mod_tr = core.get_modpath("toolranks")

-- Hoe registration function

farming.register_hoe = function(name, def)

	-- Check for : prefix (register new hoes in your mod's namespace)
	if name:sub(1,1) ~= ":" then name = ":" .. name end

	-- Check def table
	if def.description == nil then def.description = S("Hoe") end

	if def.inventory_image == nil then def.inventory_image = "unknown_item.png" end

	if def.max_uses == nil then def.max_uses = 30 end

	-- add hoe group
	def.groups = def.groups or {}
	def.groups.hoe = 1

	-- Register the tool
	core.register_tool(name, {
		description = def.description,
		inventory_image = def.inventory_image,
		groups = def.groups,
		sound = {breaks = "default_tool_breaks"},
		damage_groups = def.damage_groups or {fleshy = 1},

		on_use = function(itemstack, user, pointed_thing)
			return farming.hoe_on_use(itemstack, user, pointed_thing, def.max_uses)
		end
	})

	-- Register its recipe
	if def.recipe then
		core.register_craft({ output = name:sub(2), recipe = def.recipe })

	elseif def.material then

		core.register_craft({
			output = name:sub(2),
			recipe = {
				{def.material, def.material, ""},
				{"", "group:stick", ""},
				{"", "group:stick", ""}
			}
		})
	end
end

-- Turns dirt with group soil=1 into soil

function farming.hoe_on_use(itemstack, user, pointed_thing, uses)

	local pt = pointed_thing or {}
	local is_used = false

	-- am I going to hoe the top of a dirt node?
	if pt.type == "node" and pt.above.y == pt.under.y + 1 then

		local under = core.get_node(pt.under)
		local upos = pointed_thing.under

		if core.is_protected(upos, user:get_player_name()) then
			core.record_protection_violation(upos, user:get_player_name())
			return
		end

		local p = {x = pt.under.x, y = pt.under.y + 1, z = pt.under.z}
		local above = core.get_node(p)

		-- return if any of the nodes is not registered
		if not core.registered_nodes[under.name]
		or not core.registered_nodes[above.name] then return end

		-- check if the node above the pointed thing is air
		if above.name ~= "air" then return end

		-- check if pointing at dirt
		if core.get_item_group(under.name, "soil") ~= 1 then return end

		-- check if (wet) soil defined
		local ndef = core.registered_nodes[under.name]

		if ndef.soil == nil or ndef.soil.wet == nil or ndef.soil.dry == nil then
			return
		end

		if core.is_protected(pt.under, user:get_player_name()) then
			core.record_protection_violation(pt.under, user:get_player_name())
			return
		end

		-- turn the node into soil, wear out item and play sound
		core.set_node(pt.under, {name = ndef.soil.dry}) ; is_used = true

		core.sound_play("default_dig_crumbly", {pos = pt.under, gain = 0.5}, true)
	end

	local wdef = itemstack:get_definition()
	local wear = 65535 / (uses - 1)

	-- using hoe as weapon
	if pt.type == "object" then

		local ent = pt.ref and pt.ref:get_luaentity()
		local dir = user:get_look_dir()

		if (ent and ent.name ~= "__builtin:item"
		and ent.name ~= "__builtin:falling_node") or pt.ref:is_player() then

			pt.ref:punch(user, nil, {full_punch_interval = 1.0,
					damage_groups = wdef.damage_groups}, dir)

			is_used = true
		end
	end

	-- only when used on soil top or external entity
	if is_used then

		-- cretive doesnt wear tools but toolranks registers uses with wear so set to 1
		if farming.is_creative(user:get_player_name()) then
			if mod_tr then wear = 1 else wear = 0 end
		end

		if mod_tr then
			itemstack = toolranks.new_afteruse(itemstack, user, under, {wear = wear})
		else
			itemstack:add_wear(wear)
		end

		if itemstack:get_count() == 0 and wdef.sound and wdef.sound.breaks then
			core.sound_play(wdef.sound.breaks, {pos = pt.above, gain = 0.5}, true)
		end
	end

	return itemstack
end

-- Define Hoes

farming.register_hoe(":farming:hoe_wood", {
	description = S("Wooden Hoe"),
	inventory_image = "farming_tool_woodhoe.png",
	max_uses = 30,
	material = "group:wood"
})

core.register_craft({
	type = "fuel",
	recipe = "farming:hoe_wood",
	burntime = 5
})

farming.register_hoe(":farming:hoe_stone", {
	description = S("Stone Hoe"),
	inventory_image = "farming_tool_stonehoe.png",
	max_uses = 90,
	material = "group:stone"
})

farming.register_hoe(":farming:hoe_steel", {
	description = S("Steel Hoe"),
	inventory_image = "farming_tool_steelhoe.png",
	max_uses = 200,
	material = "default:steel_ingot",
	damage_groups = {fleshy = 2}
})

farming.register_hoe(":farming:hoe_bronze", {
	description = S("Bronze Hoe"),
	inventory_image = "farming_tool_bronzehoe.png",
	max_uses = 250,
	groups = {not_in_creative_inventory = 1},
	material = "default:bronze_ingot",
	damage_groups = {fleshy = 2}
})

farming.register_hoe(":farming:hoe_mese", {
	description = S("Mese Hoe"),
	inventory_image = "farming_tool_mesehoe.png",
	max_uses = 350,
	groups = {not_in_creative_inventory = 1},
	damage_groups = {fleshy = 3}
})

farming.register_hoe(":farming:hoe_diamond", {
	description = S("Diamond Hoe"),
	inventory_image = "farming_tool_diamondhoe.png",
	max_uses = 500,
	groups = {not_in_creative_inventory = 1},
	damage_groups = {fleshy = 3}
})

-- Toolranks support

if mod_tr then

	core.override_item("farming:hoe_wood", {
		original_description = S("Wood Hoe"),
		description = toolranks.create_description(S("Wood Hoe"))})

	core.override_item("farming:hoe_stone", {
		original_description = S("Stone Hoe"),
		description = toolranks.create_description(S("Stone Hoe"))})

	core.override_item("farming:hoe_steel", {
		original_description = S("Steel Hoe"),
		description = toolranks.create_description(S("Steel Hoe"))})

	core.override_item("farming:hoe_bronze", {
		original_description = S("Bronze Hoe"),
		description = toolranks.create_description(S("Bronze Hoe"))})

	core.override_item("farming:hoe_mese", {
		original_description = S("Mese Hoe"),
		description = toolranks.create_description(S("Mese Hoe"))})

	core.override_item("farming:hoe_diamond", {
		original_description = S("Diamond Hoe"),
		description = toolranks.create_description(S("Diamond Hoe"))})
end

-- hoe bomb function

local function hoe_area(pos, player)

	-- check for protection
	if core.is_protected(pos, player:get_player_name()) then
		core.record_protection_violation(pos, player:get_player_name())
		return
	end

	local r = 5 -- radius

	-- remove flora (grass, flowers etc.)
	local res = core.find_nodes_in_area(
			{x = pos.x - r, y = pos.y - 1, z = pos.z - r},
			{x = pos.x + r, y = pos.y + 1, z = pos.z + r},
			{"group:flora", "group:grass", "group:dry_grass", "default:dry_shrub"})

	for n = 1, #res do
		core.swap_node(res[n], {name = "air"})
	end

	-- replace dirt with tilled soil
	res = core.find_nodes_in_area_under_air(
			{x = pos.x - r, y = pos.y - 1, z = pos.z - r},
			{x = pos.x + r, y = pos.y + 2, z = pos.z + r},
			{"group:soil", "ethereal:dry_dirt"})

	for n = 1, #res do
		core.swap_node(res[n], {name = "farming:soil"})
	end
end

-- throwable hoe bomb entity

core.register_entity("farming:hoebomb_entity", {

	initial_properties = {
		physical = true,
		visual = "sprite",
		visual_size = {x = 1.0, y = 1.0},
		textures = {"farming_hoe_bomb.png"},
		collisionbox = {-0.2,-0.2,-0.2,0.2,0.2,0.2}
	},

	on_step = function(self, dtime, moveresult)

		if not self.player then
			self.object:remove() ; return
		end

		if moveresult.collides then

			local pos = vector.round(self.object:get_pos())

			pos.y = pos.y - 1 ; hoe_area(pos, self.player)

			self.object:remove()
		end
	end
})

-- actual throwing function

local function throw_potion(itemstack, player)

	local pos = player:get_pos()

	local obj = core.add_entity({
			x = pos.x, y = pos.y + 1.5, z = pos.z}, "farming:hoebomb_entity")

	if not obj then return end

	local dir = player:get_look_dir()
	local velocity = 20

	obj:set_velocity({x = dir.x * velocity, y = dir.y * velocity, z = dir.z * velocity})

	obj:set_acceleration({x = dir.x * -3, y = -9.5, z = dir.z * -3})

	obj:get_luaentity().player = player
end

-- hoe bomb item

core.register_craftitem("farming:hoe_bomb", {
	description = S("Hoe Bomb (use or throw on grassy areas to hoe land)"),
	inventory_image = "farming_hoe_bomb.png",
	groups = {flammable = 2, not_in_creative_inventory = 1},

	on_use = function(itemstack, user, pointed_thing)

		if pointed_thing.type == "node" then
			hoe_area(pointed_thing.under, user)
		else
			throw_potion(itemstack, user)

			if not farming.is_creative(user:get_player_name()) then

				itemstack:take_item()

				return itemstack
			end
		end
	end,
})

-- helper function

local function node_not_num(nodename)

	local num = #nodename:split("_")
	local str = ""

	if not num or num == 1 then return end

	for v = 1, (num - 1) do
		str = str .. nodename:split("_")[v] .. "_"
	end

	return str
end

farming.scythe_not_drops = {"farming:trellis", "farming:beanpole"}

farming.add_to_scythe_not_drops = function(item)
	table.insert(farming.scythe_not_drops, item)
end

-- Mithril Scythe (special item)

core.register_tool("farming:scythe_mithril", {
	description = S("Mithril Scythe (Use to harvest and replant crops)"),
	inventory_image = "farming_scythe_mithril.png",
	sound = {breaks = "default_tool_breaks"},

	on_use = function(itemstack, placer, pointed_thing)

		if pointed_thing.type ~= "node" then return end

		local pos = pointed_thing.under
		local name = placer:get_player_name()

		if core.is_protected(pos, name) then return end

		local node = core.get_node_or_nil(pos)

		if not node then return end

		local def = core.registered_nodes[node.name]

		if not def or not def.drop or not def.groups or not def.groups.plant then
			return
		end

		local drops = core.get_node_drops(node.name, "")

		if not drops or #drops == 0 or (#drops == 1 and drops[1] == "") then
			return
		end

		-- get crop name
		local mname = node.name:split(":")[1]
		local pname = node_not_num(node.name:split(":")[2])

		if not pname then return end

		-- add dropped items
		for _, dropped_item in pairs(drops) do

			-- dont drop items on this list
			for _, not_item in pairs(farming.scythe_not_drops) do

				if dropped_item == not_item then
					dropped_item = nil
				end
			end

			if dropped_item then

				local obj = core.add_item(pos, dropped_item)

				if obj then

					obj:set_velocity({
							x = math.random() - 0.5, y = 3, z = math.random() - 0.5})
				end
			end
		end

		-- Run script hook
		for _, callback in pairs(core.registered_on_dignodes) do
			callback(pos, node, placer)
		end

		-- play sound
		core.sound_play("default_grass_footstep", {pos = pos, gain = 1.0}, true)

		-- replace with seed or crop_1
		local replace = mname .. ":" .. pname .. "1"

		if core.registered_nodes[replace] then

			local p2 = core.registered_nodes[replace].place_param2 or 1

			core.set_node(pos, {name = replace, param2 = p2})
		else
			core.set_node(pos, {name = "air"})
		end

		if not farming.is_creative(name) then

			itemstack:add_wear(65535 / 350) -- 350 uses

			return itemstack
		end
	end
})

-- if moreores found add mithril scythe recipe

if core.get_modpath("moreores") then

	core.register_craft({
		output = "farming:scythe_mithril",
		recipe = {
			{"", "moreores:mithril_ingot", "moreores:mithril_ingot"},
			{"moreores:mithril_ingot", "", "group:stick"},
			{"", "", "group:stick"}
		}
	})
end
