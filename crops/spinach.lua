
local S = core.get_translator("farming")

-- item/seed

core.register_craftitem("farming:spinach", {
	description = S("Spinach"),
	inventory_image = "farming_spinach.png",
	groups = {compostability = 48, seed = 2, food_spinach = 1},
	on_use = core.item_eat(1),

	on_place = function(itemstack, placer, pointed_thing)
		return farming.place_seed(itemstack, placer, pointed_thing, "farming:spinach_1")
	end
})

farming.add_eatable("farming:spinach", 1)

-- crop definition

local def = {
	description = S("Spinach") .. S(" Crop"),
	drawtype = "plantlike",
	tiles = {"farming_spinach_1.png"},
	paramtype = "light",
	sunlight_propagates = true,
	waving = 1,
	walkable = false,
	buildable_to = true,
	drop = "",
	selection_box = farming.select,
	groups = {
		handy = 1, snappy = 3, flammable = 2, plant = 1, attached_node = 1,
		not_in_creative_inventory = 1, growing = 1
	},
	_mcl_hardness = farming.mcl_hardness,
	is_ground_content = false,
	sounds = farming.node_sound_leaves_defaults()
}

-- stage 1

core.register_node("farming:spinach_1", table.copy(def))

-- stage 2

def.tiles = {"farming_spinach_2.png"}
core.register_node("farming:spinach_2", table.copy(def))

-- stage 3

def.tiles = {"farming_spinach_3.png"}
def.drop = {
	items = {
		{items = {"farming:spinach"}, rarity = 1},
		{items = {"farming:spinach"}, rarity = 3}
	}
}
core.register_node("farming:spinach_3", table.copy(def))

-- stage 4

def.tiles = {"farming_spinach_4.png"}
def.groups.growing = nil
def.selection_box = farming.select_final
def.drop = {
	items = {
		{items = {"farming:spinach 2"}, rarity = 1},
		{items = {"farming:spinach"}, rarity = 2},
		{items = {"farming:spinach"}, rarity = 3},
		{items = {"farming:spinach"}, rarity = 4}
	}
}
core.register_node("farming:spinach_4", table.copy(def))

-- add to registered_plants

farming.registered_plants["farming:spinach"] = {
	crop = "farming:spinach",
	seed = "farming:spinach",
	minlight = 7,
	maxlight = farming.max_light,
	steps = 4
}

-- mapgen

core.register_decoration({
	deco_type = "simple",
	place_on = {"default:dirt_with_grass", "mcl_core:dirt_with_grass"},
	sidelen = 16,
	noise_params = {
		offset = 0,
		scale = farming.spinach,
		spread = {x = 100, y = 100, z = 100},
		seed = 910,
		octaves = 3,
		persist = 0.6
	},
	y_min = 1, y_max = 100,
	decoration = "farming:spinach_3",
	param2 = 3
})
