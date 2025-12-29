extends ColorRect

@onready var window: LootWindow = $"../../../.."


var dragging = false

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("drag item") and LootGlobal.held_item == null and LootGlobal.held_window == null:
		LootGlobal.held_window_offset = get_viewport().get_mouse_position() - window.global_position
		LootGlobal.held_window = window
		window.get_parent().move_child(window,-1)
