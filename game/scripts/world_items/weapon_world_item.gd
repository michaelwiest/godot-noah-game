extends WorldItem

class_name WeaponWorldItem

func _on_interactable_interacted(interactor: Interactor) -> void:
	print("weapon interaction %s" % self.item_data.name)
	if interactor.controller and interactor.controller is Player:
		var player = interactor.controller
		var weapon_scene = preload("res://scenes/weapons/red_weapon/red_weapon.tscn")
		
		if self.item_data.name == "Blue Weapon":
			weapon_scene = preload("res://scenes/weapons/blue_weapon/blue_weapon.tscn")
		
		var weapon_node = weapon_scene.instantiate()
		
		# Drop the player's current weapon at the position of this specific world item
		player.drop_current_weapon(self.global_position)
		
		# Add weapon ndoe to child and assign values
		player.add_child(weapon_node)
		player.weapon = weapon_node
		player.weapon.weapon_data = weapon_node.weapon_data as WeaponData

		self.remove_item_from_world(interactor)
