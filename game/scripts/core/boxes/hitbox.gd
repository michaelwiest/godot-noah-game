extends Area2D
class_name HitBox
	
func disable():
	monitorable = false
	monitoring = false
	visible = false

func enable():
	monitorable = true
	monitoring = true
	visible = true

# Kind of hacky signaling to pass a hit to the parent weapon. Because the
# hitbox has no notion of the force or damage that it can apply.
signal apply_damage_signal(entity: Entity)
signal apply_knockback_signal(entity: Entity)

func apply_damage(entity: Entity):
	emit_signal("apply_damage_signal", entity)

func apply_knockback(entity: Entity):
	emit_signal("apply_knockback_signal", entity)
