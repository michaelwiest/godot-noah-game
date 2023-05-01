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
	emit_signal("attack_start_signal")
	

func attack_end():
	hitbox.disable()
	sprite.visible = false
	emit_signal("attack_end_signal")

# Kind of hacky signaling to pass a hit to the parent weapon. Because the
# hitbox has no notion of the force or damage that it can apply.
signal attack_apply_hit_signal(entity: Entity)
signal attack_end_signal
signal attack_start_signal


func _on_hitbox_apply_hit_signal(entity):
	emit_signal("attack_apply_hit_signal", entity)
