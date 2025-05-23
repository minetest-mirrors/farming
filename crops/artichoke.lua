
local S = core.get_translator("farming")

-- item/seed

core.register_craftitem("farming:artichoke", {
	description = S("Artichoke"),
	inventory_image = "farming_artichoke.png",
	groups = {compostability = 48, seed = 2, food_artichoke = 1},
	on_use = core.item_eat(4),

	on_place = function(itemstack, placer, pointed_thing)
		return farming.place_seed(itemstack, placer, pointed_thing, "farming:artichoke_1")
	end
})

farming.add_eatable("farming:artichoke", 4)

-- crop definition

local def = {
	description = S("Artichoke") .. S(" Crop"),
	drawtype = "plantlike",
	tiles = {"farming_artichoke_1.png"},
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	drop = "",
	waving = 1,
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

core.register_node("farming:artichoke_1", table.copy(def))

-- stage 2

def.tiles = {"farming_artichoke_2.png"}
core.register_node("farming:artichoke_2", table.copy(def))

-- stage 3

def.tiles = {"farming_artichoke_3.png"}
core.register_node("farming:artichoke_3", table.copy(def))

-- stage 4

def.tiles = {"farming_artichoke_4.png"}
def.drop = {
	items = {
		{items = {"farming:artichoke"}, rarity = 1}
	}
}
core.register_node("farming:artichoke_4", table.copy(def))

-- stage 5 (final)

def.tiles = {"farming_artichoke_5.png"}
def.groups.growing = nil
def.selection_box = farming.select_final
def.drop = {
	items = {
		{items = {"farming:artichoke 2"}, rarity = 1},
		{items = {"farming:artichoke"}, rarity = 2}
	}
}
core.register_node("farming:artichoke_5", table.copy(def))

-- add to registered_plants

farming.registered_plants["farming:artichoke"] = {
	crop = "farming:artichoke",
	seed = "farming:artichoke",
	minlight = 13,
	maxlight = 15,
	steps = 5
}

-- mapgen

core.register_decoration({
	deco_type = "simple",
	place_on = {
		"default:dirt_with_grass", "mcl_core:dirt_with_grass", "ethereal:grove_dirt"
	},
	sidelen = 16,
	noise_params = {
		offset = 0,
		scale = farming.artichoke,
		spread = {x = 100, y = 100, z = 100},
		seed = 123,
		octaves = 3,
		persist = 0.6
	},
	y_min = 1, y_max = 13,
	decoration = "farming:artichoke_4",
	spawn_by = "group:tree", num_spawn_by = 1
})
