class_name ItemRepresentation extends TextureRect

var item:Item




func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("drag item") and LootGlobal.held_item == null:
		LootGlobal.held_item = item
		LootGlobal.hold_offset = get_viewport().get_mouse_position() - global_position
		LootGlobal.held_action = "drag item"
