extends Area2D

var target = null
var target_inside: bool = false
@onready var timer = $Timer
@export var is_attractor: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func has_target():
	return target != null

#
func _on_timer_timeout():
#	print("Lost target")
#	print(target)
	if !target_inside:
		print("Setting target null")
		target = null


func _on_body_entered(body):
	print(body)
	target = body
	target_inside = true



func _on_body_exited(body):
#	print("Timer start")
	timer.start()
	target_inside = false


#extends Area2D
#
#var targets: Array[Entity] = []
#var target_inside: bool = false
#@onready var timer = $Timer
#@onready var is_attractor: bool = true
#
## Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.
#
#func has_target():
#	return len(targets) > 0
#
##
#func _on_timer_timeout():
#	if !target_inside:
#		target = null
#
#
#func _on_body_entered(body):
##	target = body
#	if body not in targets:
#		targets.append(body)
#	target_inside = true
#
#
#
#func _on_body_exited(body):
##	print("Timer start")
#	timer.start()
#	target_inside = false
