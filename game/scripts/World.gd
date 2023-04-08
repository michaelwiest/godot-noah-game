extends Node2D

@onready var stick: Weapon = $Player/stick

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Hack for now before having equipment associated with the player
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		stick.use0()
