extends Interactor

@export var player: Player

var closest_interactable: Interactable

func _ready():
	controller = player
	
func _physics_process(delta: float) -> void:
	update_closest_interactable()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if closest_interactable:
			interact(closest_interactable)

func _on_area_exited(area: Interactable) -> void:
	if closest_interactable == area:
		unfocus(area)
	
func update_closest_interactable() -> void:
	var new_closest: Interactable = get_closest_interactable()
	# Found a new closest interactable area
	if new_closest != closest_interactable:
		# Make sure the existing closest node has not been freed yet
		if is_instance_valid(closest_interactable):
			unfocus(closest_interactable)
		
		# Focus on the new closest node
		if new_closest:
			focus(new_closest)
			
		# Update closest interactable cache
		closest_interactable = new_closest
