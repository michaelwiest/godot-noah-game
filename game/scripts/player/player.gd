extends Entity
class_name Player

signal toggle_inventory

@export var item_inventory_data: InventoryData
@export var weapon_inventory_data: WeaponInventoryData
@export var equipment_inventory_data: EquipmentInventoryData

@onready var last_direction: Vector2
@onready var weapon_force: float = 0
@onready var weapon_timer = $WeaponForceTimer
@onready var weapon: Weapon = $Weapon

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	direction = Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down")).normalized()
	if direction:
		last_direction = direction
	if direction.y:
		var velocity_y: float = velocity.y + sign(direction.y) * acceleration
		if velocity.y < 0:
			velocity.y = max(velocity_y, -max_speed * abs(direction.y))
		else:
			velocity.y = min(velocity_y, max_speed * abs(direction.y))
	else:
		
		velocity.y = move_toward(velocity.y, 0, friction)
	if direction.x:
		var velocity_x: float = velocity.x + sign(direction.x) * acceleration
		if velocity.x < 0:
			velocity.x = max(velocity_x, -max_speed * abs(direction.x))
		else:
			velocity.x = min(velocity_x, max_speed * abs(direction.x))
	else: 
		velocity.x = move_toward(velocity.x, 0, friction)
	
	# This isn't super cool or useful so maybe we wanna remove it.
	if weapon_force > 0:
		var acc: float = (weapon_force / mass)
		velocity += Vector2(last_direction.x * acc, last_direction.y * acc)
	move_and_slide()
	
	# Open inventory menu if action pressed
	inventory_input() 


func _on_weapon_force_timer_timeout():
	weapon_force = 0
	
func inventory_input() -> void:
	if Input.is_action_just_pressed("inventory"):
		toggle_inventory.emit()

func drop_current_weapon(drop_position: Vector2) -> void:
	# Make sure a weapon has been picked up 
	if weapon.weapon_data:
		# Create WeaponWorlditem to drop in the world at the current player location
		var weapon_item_scene: PackedScene = load("res://scenes/world_items/weapon_world_item.tscn")
		var weapon_item_node: WeaponWorldItem = weapon_item_scene.instantiate()
		weapon_item_node.item_data = weapon.weapon_data
		
		# Set drop position
		weapon_item_node.position = drop_position
		
		# Add WeaponWorldItem to the scene tree
		get_tree().get_root().add_child(weapon_item_node)
		
		# Remove the existing weapon from the player's node tree
		weapon.queue_free()
