-- rainbow_ore_grayscale.lua

local S = core.get_translator(rainbow_ore.modname)

local items = {
	{
		rainbow = "rainbow_ore:rainbow_ore_pickaxe",
		gray = "rainbow_ore:rainbow_ore_pickaxe_gray",
		description = S("Grayscale Rainbow Pickaxe"),
		inventory_image = "grayscaled_rainbow_ore_pickaxe.png",
	},
	{
		rainbow = "rainbow_ore:rainbow_ore_axe",
		gray = "rainbow_ore:rainbow_ore_axe_gray",
		description = S("Grayscale Rainbow Axe"),
		inventory_image = "grayscaled_rainbow_ore_axe.png",
	},
	{
		rainbow = "rainbow_ore:rainbow_ore_shovel",
		gray = "rainbow_ore:rainbow_ore_shovel_gray",
		description = S("Grayscale Rainbow Shovel"),
		inventory_image = "grayscaled_rainbow_ore_shovel.png",
		wield_image = "grayscaled_rainbow_ore_shovel.png^[transformR90",
	},
	{
		rainbow = "rainbow_ore:rainbow_ore_sword",
		gray = "rainbow_ore:rainbow_ore_sword_gray",
		description = S("Grayscale Rainbow Sword"),
		inventory_image = "grayscaled_rainbow_ore_sword.png",
	},
	{
		rainbow = "rainbow_ore:rainbow_ore_helmet",
		gray = "rainbow_ore:rainbow_ore_helmet_gray",
		description = S("Grayscale Rainbow Helmet"),
		inventory_image = "grayscaled_rainbow_ore_helmet_inv.png",
		texture = "grayscaled_rainbow_ore_rainbow_ore_helmet.png",
		preview = "grayscaled_rainbow_ore_rainbow_ore_helmet_preview.png",
	},
	{
		rainbow = "rainbow_ore:rainbow_ore_chestplate",
		gray = "rainbow_ore:rainbow_ore_chestplate_gray",
		description = S("Grayscale Rainbow Chestplate"),
		inventory_image = "grayscaled_rainbow_ore_chestplate_inv.png",
		texture = "grayscaled_rainbow_ore_rainbow_ore_chestplate.png",
		preview = "grayscaled_rainbow_ore_rainbow_ore_chestplate_preview.png",
	},
	{
		rainbow = "rainbow_ore:rainbow_ore_leggings",
		gray = "rainbow_ore:rainbow_ore_leggings_gray",
		description = S("Grayscale Rainbow Leggings"),
		inventory_image = "grayscaled_rainbow_ore_leggings_inv.png",
		texture = "grayscaled_rainbow_ore_rainbow_ore_leggings.png",
		preview = "grayscaled_rainbow_ore_rainbow_ore_leggings_preview.png",
	},
	{
		rainbow = "rainbow_ore:rainbow_ore_boots",
		gray = "rainbow_ore:rainbow_ore_boots_gray",
		description = S("Grayscale Rainbow Boots"),
		inventory_image = "grayscaled_rainbow_ore_boots_inv.png",
		texture = "grayscaled_rainbow_ore_rainbow_ore_boots.png",
		preview = "grayscaled_rainbow_ore_rainbow_ore_boots_preview.png",
	},
	{
		rainbow = "rainbow_ore:rainbow_ore_shield",
		gray = "rainbow_ore:rainbow_ore_shield_gray",
		description = S("Grayscale Rainbow Shield"),
		inventory_image = "grayscaled_rainbow_ore_shield_inv.png",
		texture = "grayscaled_rainbow_ore_rainbow_ore_shield.png",
		preview = "grayscaled_rainbow_ore_rainbow_ore_shield_preview.png",
	},
}

local toggle = {}

for _, item in ipairs(items) do
	toggle[item.rainbow] = item.gray
	toggle[item.gray] = item.rainbow

	local rainbow_def = core.registered_items[item.rainbow]

	if rainbow_def then
		local gray_def = table.copy(rainbow_def)

		gray_def.description = item.description
		gray_def.inventory_image = item.inventory_image
		gray_def.groups = table.copy(rainbow_def.groups or {})
		gray_def.groups.not_in_creative_inventory = 1

		if item.wield_image then
			gray_def.wield_image = item.wield_image
		elseif rainbow_def.wield_image then
			gray_def.wield_image = rainbow_def.wield_image
		else
			gray_def.wield_image = item.inventory_image
		end

		if item.texture then
			gray_def.texture = item.texture
		end

		if item.preview then
			gray_def.preview = item.preview
		end

		core.register_tool(item.gray, gray_def)
	end

	core.register_craft({
		type = "shapeless",
		output = item.gray,
		recipe = {item.rainbow},
	})

	core.register_craft({
		type = "shapeless",
		output = item.rainbow,
		recipe = {item.gray},
	})
end

core.register_on_craft(function(itemstack, player, old_craft_grid, craft_inv)
	local input

	for _, stack in ipairs(old_craft_grid) do
		if not stack:is_empty() and toggle[stack:get_name()] then
			input = stack
			break
		end
	end

	if not input then
		return
	end

	-- Only allow completely unworn items to be converted.
	if input:get_wear() ~= 0 then
		local inv = player:get_inventory()
		local leftover = inv:add_item("main", input)

		if not leftover:is_empty() then
			core.item_drop(leftover, player, player:get_pos())
		end

		return ItemStack("")
	end

	return ItemStack(toggle[input:get_name()])
end)