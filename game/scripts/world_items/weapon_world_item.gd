extends WorldItem

class_name WeaponWorldItem

func _on_interactable_interacted(interactor: Interactor) -> void:
	print("weapon interaction %s" % self.item_data.name)
	if interactor.controller and interactor.controller is Player:
		var player = interactor.controller as Player
		
		# Drop the player's current weapon at the position of this specific world item
		player.drop_current_weapon(self.global_position)
		
		var new_slot_data: SlotData = SlotData.new()
		new_slot_data.item_data = self.item_data as WeaponData
		player.weapon_inventory_data.replace_slot_data(new_slot_data, 0)

		self.remove_item_from_world(interactor)
