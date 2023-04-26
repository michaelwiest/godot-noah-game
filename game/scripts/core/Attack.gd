extends Node2D
class_name Attack

@onready var animation_player = $AnimationPlayer
@onready var hitbox = $Marker2D/hitbox
@onready var sprite = $Sprite2D

func use():
	animation_player.play("use")

func attack_start():
	hitbox.enable()
	sprite.visible = true
	

func attack_end():
	hitbox.disable()
	sprite.visible = false

# Kind of hacky signaling to pass a hit to the parent weapon. Because the
# hitbox has no notion of the force or damage that it can apply.
signal attack_apply_hit_signal(entity: Entity)
#signal attack_apply_knockback_signal(entity: Entity)
#
#
#func _on_hitbox_apply_damage_signal(entity: Entity):
#	emit_signal("attack_apply_damage_signal", entity)
#
#
#func _on_hitbox_apply_knockback_signal(entity: Entity):
#	emit_signal("attack_apply_knockback_signal", entity)



func _on_hitbox_apply_hit_signal(entity):
	print("Attack apply hit")
	emit_signal("attack_apply_hit_signal", entity)
