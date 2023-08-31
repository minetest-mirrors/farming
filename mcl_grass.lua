
-- Override mcl grass and have it drop Wheat and Oat Seeds

minetest.override_item("mcl_flowers:tallgrass", {
	drop = {
		max_items = 1,
		items = {
			{items = {"mcl_farming:wheat_seeds"}, rarity = 5},
			{items = {"farming:seed_oat"},rarity = 5},
			{items = {"farming:seed_barley"}, rarity = 5},
			{items = {"farming:seed_rye"},rarity = 5},
			{items = {"farming:seed_cotton"}, rarity = 8},
			{items = {"farming:seed_rice"},rarity = 8}
		}
	}
})
