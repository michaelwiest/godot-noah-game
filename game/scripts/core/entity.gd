extends CharacterBody2D
class_name Entity

@export var stats: Stats
@export var mass: float = 1.0
@export var max_speed: float = 10.0
@export var friction: float = 5.0
@export var acceleration: float = 5.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
