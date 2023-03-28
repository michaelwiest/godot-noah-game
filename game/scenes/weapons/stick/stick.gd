extends Weapon


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func use():
	UseAnimation.play("use")
