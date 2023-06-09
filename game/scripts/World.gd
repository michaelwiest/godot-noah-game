extends Node2D

#@onready var weapon: Weapon = $Player/Weapon
@onready var inventory_interface: Control = $UI/InventoryInterface
@onready var player: Player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	inventory_interface.set_item_inventory_data(player.item_inventory_data)
	inventory_interface.set_weapon_inventory_data(player.weapon_inventory_data)
	inventory_interface.set_equipment_inventory_data(player.equipment_inventory_data)
	player.toggle_inventory.connect(toggle_inventory_interface)


# Hack for now before having equipment associated with the player
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		if is_instance_valid(player.weapon) and player.weapon and player.weapon.weapon_data:
			player.weapon.use()

func toggle_inventory_interface() -> void:
	inventory_interface.visible = not inventory_interface.visible
	
	# Enable mouse if when inventory menue is open
  # TODO(zack): Handle mouse disable if needed for inventory input
	if inventory_interface.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
