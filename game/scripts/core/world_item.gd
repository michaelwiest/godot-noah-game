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
			print("%s picked up %s" % [interactor, $Interactable])
			if interactor.controller:
				interactor.controller.pick_up_world_item(self)
				
		item_data.InteractionType.EQUIP:
			print("%s Equipped up %s" % [interactor, $Interactable])
			
			# TODO: This is a placeholder to allow the player to equip world items
			if interactor.controller:
				interactor.controller.equip_world_item(self)
	
	
	
