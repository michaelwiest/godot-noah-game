extends Entity
class_name Enemy

@onready var target_computer: Node2D = $TargetComputer
@onready var target_position: Vector2 = global_position
@onready var target_direction: Vector2 = Vector2.ZERO

func _ready():
	# Annoyingly this isn't inheriting from parent class?
	sprite.material.set_shader_parameter("show", true)
	# Don't get attracted or repelled by yourself.
	target_computer.set_ignored_body(self)
	

func at_destination(delta):
	# This should be cleaner / not such an obvious hack.
	return global_position.distance_to(target_position) <= 5 # (max_speed * delta) / 100

func _process(delta):
	
	var target = target_computer.compute_target(global_position)
	if target != null:
		target_position = target
	else:
		target_position = global_position
	target_direction = global_position.direction_to(target_position)
	# This velocity is probably messed up. it acts weird.
	if !at_destination(delta):
		velocity = velocity.move_toward(target_direction * max_speed, 
										acceleration * delta) 
	else:
		pass
	move_and_slide()
	
