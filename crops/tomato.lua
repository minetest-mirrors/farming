
--[[
	Textures edited from:
	http://www.minecraftforum.net/forums/mapping-and-modding/minecraft-mods/1288375-food-plus-mod-more-food-than-you-can-imagine-v2-9)
]]

local S = core.get_translator("farming")

-- item/seed

core.register_craftitem("farming:tomato", {
	description = S("Tomato"),
	inventory_image = "farming_tomato.png",
	groups = {compostability = 45, seed = 2, food_tomato = 1},
	on_use = core.item_eat(4),

	on_place = function(itemstack, placer, pointed_thing)
		return farming.place_seed(itemstack, placer, pointed_thing, "farming:tomato_1")
	end
})

farming.add_eatable("farming:tomato", 4)

-- crop definition

local def = {
	description = S("Tomato") .. S(" Crop"),
	drawtype = "plantlike",
	tiles = {"farming_tomato_1.png"},
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

core.register_node("farming:tomato_1", table.copy(def))

-- stage2

def.tiles = {"farming_tomato_2.png"}
core.register_node("farming:tomato_2", table.copy(def))

-- stage 3

def.tiles = {"farming_tomato_3.png"}
core.register_node("farming:tomato_3", table.copy(def))

-- stage 4

def.tiles = {"farming_tomato_4.png"}
core.register_node("farming:tomato_4", table.copy(def))

-- stage 5

def.tiles = {"farming_tomato_5.png"}
core.register_node("farming:tomato_5", table.copy(def))

-- stage 6

def.tiles = {"farming_tomato_6.png"}
core.register_node("farming:tomato_6", table.copy(def))

-- stage 7

def.tiles = {"farming_tomato_7.png"}
def.drop = {
	items = {
		{items = {"farming:tomato"}, rarity = 1},
		{items = {"farming:tomato"}, rarity = 3}
	}
}
core.register_node("farming:tomato_7", table.copy(def))

-- stage 8 (final)

def.tiles = {"farming_tomato_8.png"}
def.groups.growing = nil
def.selection_box = farming.select_final
def.drop = {
	items = {
		{items = {"farming:tomato 2"}, rarity = 1},
		{items = {"farming:tomato"}, rarity = 2},
		{items = {"farming:tomato"}, rarity = 3},
		{items = {"farming:tomato"}, rarity = 4}
	}
}
core.register_node("farming:tomato_8", table.copy(def))

-- add to registered_plants

farming.registered_plants["farming:tomato"] = {
	crop = "farming:tomato",
	seed = "farming:tomato",
	minlight = farming.min_light,
	maxlight = farming.max_light,
	steps = 8
}

-- mapgen

core.register_decoration({
	deco_type = "simple",
	place_on = {
		"default:dirt_with_grass", "mcl_core:dirt_with_grass", "ethereal:prairie_dirt"
	},
	sidelen = 16,
	noise_params = {
		offset = 0,
		scale = farming.tomato,
		spread = {x = 100, y = 100, z = 100},
		seed = 365,
		octaves = 3,
		persist = 0.6
	},
	y_min = 5, y_max = 25,
	decoration = "farming:tomato_7"
})
