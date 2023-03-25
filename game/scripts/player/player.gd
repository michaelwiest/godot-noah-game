extends Entity
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var direction: Vector2 = Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down"))
	if direction:
		var velocity_y: float = velocity.y + sign(direction.y) * acceleration
		if velocity.y < 0:
			velocity.y = max(velocity_y, -max_speed * abs(direction.y))
		else:
			velocity.y = min(velocity_y, max_speed * abs(direction.y))
		var velocity_x: float = velocity.x + sign(direction.x) * acceleration
		if velocity.x < 0:
			velocity.x = max(velocity_x, -max_speed * abs(direction.x))
		else:
			velocity.x = min(velocity_x, max_speed * abs(direction.x))
	else:
		velocity.x = move_toward(velocity.x, 0, friction)
		velocity.y = move_toward(velocity.y, 0, friction)
	move_and_slide()
