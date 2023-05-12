extends Node2D
class_name Attack

@onready var animation_player = $AnimationPlayer
@onready var hitbox = $Marker2D/hitbox
@onready var sprite = $Sprite2D
	
# Kind of hacky signaling to pass a hit to the parent weapon. Because the
# hitbox has no notion of the force or damage that it can apply.
signal attack_apply_hit_signal(entity: Entity)
signal attack_end_signal
signal attack_start_signal

func use():
	animation_player.play("use")

func attack_start():
	enable()
	attack_start_signal.emit()
	
func enable():
	hitbox.enable()
	sprite.visible = true

func disable():
	hitbox.disable()
	sprite.visible = false

func attack_end():
	disable()
	attack_end_signal.emit()




func _on_hitbox_apply_hit_signal(entity):
	attack_apply_hit_signal.emit(entity)
