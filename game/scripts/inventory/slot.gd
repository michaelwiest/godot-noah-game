extends PanelContainer

signal on_slot_clicked(node_index: int, button_index: int)

@onready var texture_rect: TextureRect = $MarginContainer/TextureRect
@onready var quantity_label: Label = $QuantityLabel


func set_slot_data(slot_data: SlotData) -> void:
	var item_data = slot_data.item_data
	texture_rect.texture = item_data.texture
	tooltip_text = "%s\n$s" % [item_data.name, item_data.description]
	
	if slot_data.quantity > 1:
		quantity_label.text = "x%s" % slot_data.quantity
		quantity_label.visible = true
	else:
		quantity_label.hide()


## Handle GUI events on the inventory slot
## This should emit a signal that the slot was clicked and send the slot index 
## (index of the current node in the grid and if the left or right mouse button was clicked)
func _on_gui_input(event):
	# When the slot recieves an event take action if either
	# of the mouse buttons are pressed (left or right)
	if (
		event is InputEventMouseButton 
		and (
			event.button_index == MOUSE_BUTTON_LEFT 
			or event.button_index == MOUSE_BUTTON_RIGHT
		)
		and event.is_pressed()
	):
		on_slot_clicked.emit(get_index(), event.button_index)
