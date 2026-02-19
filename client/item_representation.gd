class_name ItemRepresentation extends TextureRect

var background_panel: Panel:
	get: return $Panel

func _init() -> void:
	pivot_offset = size/2.

var item:Item = null:
	set(val):
		item = val
		texture=item.sprite
		update_rotation.call_deferred()
		item.stack_updated.connect(update_stack)
		background_panel.add_theme_stylebox_override(&"panel", item.definition.background_style_box)
		update_stack()

func update_stack() -> void:
	queue_redraw()

func update_rotation() -> void:
	pivot_offset = size/2.
	rotation = PI/2 if item.container_details.rotated else 0.
	queue_redraw()
	#stack_label.rotation = -rotation


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


const stack_text_offset_from_bottom = 4

func _draw() -> void:
	if item.stack_size == 1: return
	draw_set_transform(Vector2.ZERO,-rotation)
	var my_top_left := Vector2.ZERO
	if rotation != 0: my_top_left.x -= size.y
	var my_bottom_right := my_top_left + (size if rotation == 0 else ItemContainer.transposed_vector2(size))
	var my_bottom_left := Vector2(my_top_left.x, my_bottom_right.y)
	var draw_position:Vector2 = my_bottom_left-Vector2(0,stack_text_offset_from_bottom)
	var text:String =  str(item.stack_size)
	var width:float = my_bottom_right.x-my_bottom_left.x
	draw_string_outline(LootGlobal.DEFAULT_FONT, draw_position,text,HORIZONTAL_ALIGNMENT_RIGHT,width,16,6,Color.BLACK)
	draw_string(LootGlobal.DEFAULT_FONT, draw_position, text,HORIZONTAL_ALIGNMENT_RIGHT, width)
