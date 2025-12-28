class_name ItemRepresentation extends TextureRect

func _init() -> void:
	pivot_offset = size/2.

var item:Item = null:
	set(val):
		item = val
		update_rotation()


func update_rotation() -> void:
	rotation = PI/2 if item.container_details.rotated else 0.

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("drag item") and LootGlobal.held_item == null:
		LootGlobal.held_item = item
		LootGlobal.hold_offset = get_viewport().get_mouse_position() - global_position
		if rotation: LootGlobal.hold_offset.x += size.x#/2.
		LootGlobal.held_action = "drag item"
