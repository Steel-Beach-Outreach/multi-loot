extends Control

var held_item:Item = null:
	set(val):
		held_item=val
		hold_rotate=false
var hold_offset:=Vector2.ZERO
var held_action:String = ""
var hold_rotate:bool = false
var held_window:LootWindow = null
var held_window_offset:Vector2

func _ready() -> void:
	z_index=1000

func _draw() -> void:
	if held_item:
		var to_draw_rect:Rect2 = Rect2(get_viewport().get_mouse_position()-hold_offset,held_item.sprite.get_size())
		if held_item.container_details.rotated != hold_rotate:
			draw_set_transform(Vector2.ZERO,PI/2)
			var transposer := to_draw_rect.position.x
			to_draw_rect.position.x = to_draw_rect.position.y
			to_draw_rect.position.y = -transposer
		draw_texture_rect(held_item.sprite, to_draw_rect, false, Color.WHITE)
	
func _process(_delta: float) -> void:
	if held_window:
		if not Input.is_action_pressed("drag item"):
			held_window = null
		else:
			held_window.position = get_viewport().get_mouse_position()-held_window_offset
	queue_redraw()

func _input(event: InputEvent) -> void:
	if not held_item: return
	if event.is_action_pressed("rotate item"):
		hold_rotate = not hold_rotate
		hold_offset = hold_offset.rotated(PI/2 if hold_rotate != held_item.container_details.rotated else -PI/2)
		return
	if event.is_action_pressed("escape"):
		held_item=null
		return


func try_move_item_to(item:Item, destination:Item.ContainerDetails) -> void:
	var container := destination.container
	if not destination.can_take_item(item): return
	item.container_details.container.remove_item(item)
	container.put_item(item,destination.slot, destination.rotated)
	if item == held_item: held_item=null
