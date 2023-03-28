extends Area2D
class_name HurtBox


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#func _on_area_entered(area):
#	print(area)
#	set_deferred("collision.disabled", true)
#	set_deferred("monitoring", false)
#	if !is_invincible():
#		invincibility_timer.start()
#		hit_timer.start()
#		invincible = true

#func _on_timer_timeout():
#	invincible = false
##	set_deferred("collision.disabled", false)
#	set_deferred("monitoring", true)
#
#
#func compute_knockback(area):
##	print("computing knockback")
#	var knockback_direction = area.global_position.direction_to(global_position)
##	print(knockback_direction * area.force / mass)
#	return knockback_direction * area.force / mass


func _on_area_entered(area):
	print(area)
	pass # Replace with function body.
