extends Entity
class_name Player

@onready var last_direction: Vector2
@onready var weapon_force: float = 0
@onready var weapon_timer = $WeaponForceTimer
#@onready var direction: Vector2 = Vector2(1, 0)
# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.


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
#	print("PLAYER POSITION ", global_position)


# In theory this would be a more generic signal that gets attached on
# equip.
func _on_stick_move_player(player_force):
	weapon_force = player_force
	weapon_timer.start()


func _on_weapon_force_timer_timeout():
	weapon_force = 0
