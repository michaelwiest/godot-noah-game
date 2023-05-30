extends Entity
class_name Player

signal toggle_inventory

@export var item_inventory_data: InventoryData
@export var weapon_inventory_data: WeaponInventoryData
@export var equipment_inventory_data: EquipmentInventoryData

@onready var last_direction: Vector2
@onready var weapon_force: float = 0
@onready var weapon_timer = $WeaponForceTimer

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

## Adds world_item to equipment slot and instances a Weapon for the player to use
func equip_world_item(world_item: WorldItem) -> void:
	pass
