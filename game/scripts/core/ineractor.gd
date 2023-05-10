extends Area2D

class_name Interactor

# Node doing the interacting
var controller: Node2D

func focus(interactable: Interactable):
	interactable.focused.emit(self)

func unfocus(interactable: Interactable):
	interactable.unfocused.emit(self)

func interact(interactable: Interactable):
	interactable.interacted.emit(self)

func get_closest_interactable() -> Interactable:
	var interactable_areas: Array[Area2D] = get_overlapping_areas()
	var distance: float
	var closest_distance: float = INF
	var closest_interactable: Interactable
	
	for interactable in interactable_areas:
		distance = interactable.global_position.distance_to(global_position)
		
		if distance < closest_distance:
			closest_interactable = interactable as Interactable
			closest_distance = distance
	
	return closest_interactable
