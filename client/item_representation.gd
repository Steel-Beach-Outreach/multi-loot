class_name ItemRepresentation extends TextureRect

#var item_texture: TextureRect:
#	get: return $ItemTexture

var stack_label: Label:
	get: return $StackLabel

func _init() -> void:
	pivot_offset = size/2.

var item:Item = null:
	set(val):
		item = val
		texture=item.sprite
		update_rotation.call_deferred()
		item.stack_updated.connect(update_stack)
		update_stack()

func update_stack() -> void:
	stack_label.text = str(item.stack_size)
	stack_label.visible = item.stack_size != 1
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
		
const DEFAULT_FONT = preload("uid://dnevlpicxings")

func _draw() -> void:
	draw_set_transform(Vector2.ZERO,-rotation)
	var my_top_left := Vector2.ZERO
	if rotation != 0: my_top_left.x -= size.y
	var my_bottom_right := my_top_left + (size if rotation == 0 else ItemContainer.transposed_vector2(size))
	draw_string(DEFAULT_FONT, my_bottom_right, "wolno",HORIZONTAL_ALIGNMENT_CENTER,  100)
