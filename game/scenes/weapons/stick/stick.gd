extends Weapon


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func use0():
	UseAnimation.play("use0")


func use1():
	UseAnimation.play("use1")

func use2():
	UseAnimation.play("use2")
