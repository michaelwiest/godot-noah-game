extends Resource
class_name ItemData

enum InteractionType {
	INTERACT,
	PICK_UP,
	EQUIP,
	NOT_INTERACTABLE,
}

@export var name: String = ""
@export_multiline var description: String = ""
@export var stackable: bool = false
@export var texture: AtlasTexture
@export var interaction_type: InteractionType = InteractionType.NOT_INTERACTABLE

