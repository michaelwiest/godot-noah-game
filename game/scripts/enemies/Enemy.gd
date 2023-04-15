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
	return global_position.distance_to(target_position) <= 16 # (max_speed * delta) / 100

func _process(delta):
	# Right now there is no notion if the Enemy is at its destination. Fine.
	target_direction = target_computer.compute_target_direction(global_position)
	if target_direction != Vector2.ZERO:
		at_destination(delta)
		target_position = global_position + target_direction * 50
		velocity = velocity.move_toward(target_direction * max_speed, 
										acceleration) 
	move_and_slide()
	
