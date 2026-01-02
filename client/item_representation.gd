class_name ItemRepresentation extends TextureRect

func _init() -> void:
	pivot_offset = size/2.

var item:Item = null:
	set(val):
		item = val
		texture=item.sprite
		update_rotation()


func update_rotation() -> void:
	rotation = PI/2 if item.container_details.rotated else 0.

var last_click:int = 0

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("drag item") and LootGlobal.held_item == null and LootGlobal.held_window == null:
		if Time.get_ticks_msec() - last_click< 200:
			double_click()
			return
		last_click = Time.get_ticks_msec()
		await get_tree().create_timer(0.1).timeout
		if event.is_action_pressed("drag item") and LootGlobal.held_item == null and LootGlobal.held_window == null:
			LootGlobal.held_item = item
			LootGlobal.held_action = "drag item"
func double_click() -> void:
	if item.container:
		LootGlobal.open_container(item.container)
