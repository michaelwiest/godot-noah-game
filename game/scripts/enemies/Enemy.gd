extends Entity
class_name Enemy

@onready var target_computer: Node2D = $TargetComputer
@onready var target_position: Vector2 = global_position
@onready var target_direction: Vector2 = Vector2.ZERO

func _ready():
	# Annoyingly i have to set this here too. womp womp. 
	target_computer.set_ignored_body(self)
	sprite.material.set_shader_parameter("show", true)
	print("Setting ignore for: ", self)

func at_destination(delta):
	return global_position.distance_to(target_position) <= 2 # (max_speed * delta) / 100

func _process(delta):
	var target = target_computer.compute_target(global_position)
	if target != null:
		target_position = target
	else:
		target_position = global_position
#	print("TARGET: ", target)
#	print("SELF: ", global_position)
	target_direction = global_position.direction_to(target_position)
	# This velocity is probably messed up. it acts weird.
	if !at_destination(delta):
		velocity = velocity.move_toward(target_direction * max_speed, 
										acceleration * delta) 
	else:
		pass
#		print("at destination")
	move_and_slide()
	
