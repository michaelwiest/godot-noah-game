extends Entity
class_name Enemy

@onready var target_computer: Node2D = $TargetComputer
@onready var target_looker: Node2D = $TargetLooker
@onready var target_position: Vector2 = global_position
@onready var target_direction: Vector2 = Vector2.ZERO
@onready var facing_direction: Vector2 = Vector2.RIGHT

func _ready():
	# Annoyingly this isn't inheriting from parent class?
	sprite.material.set_shader_parameter("show", true)
	# Don't get attracted or repelled by yourself.
	target_computer.set_ignored_body(self)
	

func _set_rotation():
	"""We aren't rotation the class itself so rotate relevant sub-children."""
	if target_direction != Vector2.ZERO:
		facing_direction = target_direction
		target_looker.rotation = facing_direction.angle()

func at_destination(delta):
	# This should be cleaner / not such an obvious hack.
	return global_position.distance_to(target_position) <= 16

func targetting_process():
	target_direction = target_computer.compute_target_direction(global_position)
	_set_rotation()

func _process(delta):
	# Right now there is no notion if the Enemy is at its destination. Fine.
	targetting_process()
	if target_direction != Vector2.ZERO:
		target_position = global_position + target_direction * 50
		velocity = velocity.move_toward(target_direction * max_speed, 
										acceleration) 
	move_and_slide()
	print(target_looker.can_see_player())
	
