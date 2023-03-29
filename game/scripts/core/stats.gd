extends Node
class_name Stats

@export var max_health: int:
	set(value):
			max_health = max(1, value)
			emit_signal("max_health_changed", max_health)
			self.current_health = min(current_health, max_health)
	get:
		return max_health

		
@export var current_health: int = max_health :
	get:
		return current_health
	set(value):
		emit_signal("health_changed", value)
		current_health = min(value, max_health)
		set_health_helper()

func _ready():
	current_health = max_health

signal no_health

signal health_changed
signal max_health_changed


func set_health_helper():
	if current_health <= 0:
		emit_signal("no_health")
#

func hurt_amount(amount: int):
	current_health -= amount

func heal_amount(amount: int):
	current_health -= amount
