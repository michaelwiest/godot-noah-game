extends WorldItem

class_name WeaponWorldItem

func _on_interactable_interacted(interactor: Interactor) -> void:
	print("weapon interaction")
	if interactor.controller and interactor.controller is Player:
		var player = interactor.controller
		var red_weapon_scene = preload("res://scenes/weapons/red_weapon/red_weapon.tscn")
		var red_weapon = red_weapon_scene.instantiate()
		
		player.weapon.queue_free()
		player.add_child(red_weapon)
		player.weapon = red_weapon
		player.weapon.weapon_data = red_weapon.weapon_data as WeaponData

		self.remove_item_from_world(interactor)
		
		#player.equip_weapon_world_item(self)
