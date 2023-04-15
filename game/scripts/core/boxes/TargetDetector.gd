"""
This should be extended to handle multiple detected objects.
"""
extends Area2D

var target = null
var target_inside: bool = false
@onready var timer = $Timer
@export var is_attractor: bool = true
@export var ignored_body: CharacterBody2D

func has_target():
	return target != null

#
func _on_timer_timeout():
	if !target_inside:
		target = null


func _on_body_entered(body):
	if ignored_body != null and body != ignored_body:
		target = body
		target_inside = true



func _on_body_exited(body):
	timer.start()
	target_inside = false
