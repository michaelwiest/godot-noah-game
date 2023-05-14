extends Node2D

## WorldItem should be used as a base class to other world items like doors, weapons, edible items
class_name WorldItem

@export var item_data: ItemData

@onready var item_sprite: Sprite2D = $ItemSprite2D
@onready var info_sprite: Sprite2D = $InfoSprite2D

func _ready():
	item_sprite.texture = item_data.texture
	info_sprite.visible = false
	
func show_info_sprite():
	info_sprite.visible = true

func hide_info_sprite():
	info_sprite.visible = false

func _on_interactable_focused(interactor: Interactor) -> void:
	if info_sprite:
		show_info_sprite()

func _on_interactable_unfocused(interactor: Interactor) -> void:
	if info_sprite:
		hide_info_sprite()
		
func _on_interactable_interacted(interactor: Interactor) -> void:
	## TODO: For now I have added an interaction type to the item data but this logic could be moved to child classes
	##       e.g. A WeaponWorldItem may have different interact logic than an EdibleWorldItem
	match item_data.interaction_type:
		item_data.InteractionType.INTERACT:
			print("%s interacted with %s" % [interactor, $Interactable])
			# TODO: Do some generic Interaction here
			
		item_data.InteractionType.PICK_UP:
			# Check that controller exists and has an InventoryData
			if interactor.controller and interactor.controller.inventory_data:
				var controller_inventory: InventoryData = interactor.controller.inventory_data
				var is_picked_up: bool = add_item_to_inventory(controller_inventory)
				
				# When item is picked up we want to remove it from the screen
				if is_picked_up:
					queue_free()
				
		item_data.InteractionType.EQUIP:
			print("%s Equipped up %s" % [interactor, $Interactable])
	
## Add the current WorldItem to specified inventory
func add_item_to_inventory(inventory_data: InventoryData) -> bool:
	var slot_data: SlotData = SlotData.new().create_single_slot_data(self.item_data)
	return inventory_data.insert_slot_data(slot_data)

## Add any clean up actions required to remove item from world
func remove_item_from_world(interactor: Interactor) -> void:
	self.queue_free()
