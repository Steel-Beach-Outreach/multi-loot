extends Control

var held_item:Item = null:
	set(val):
		held_item=val
		hold_rotate=false
var hold_offset:=Vector2.ZERO
var held_action:String = ""
var hold_rotate:bool = false

func _ready() -> void:
	z_index=1000
	
func _draw() -> void:
	if held_item:
		var to_draw_rect:Rect2 = Rect2(get_viewport().get_mouse_position()-hold_offset,held_item.sprite.get_size())
		draw_texture_rect(held_item.sprite, to_draw_rect, false, Color.WHITE, held_item.container_details.rotated != hold_rotate)
	
func _process(_delta: float) -> void:
	queue_redraw()

func _input(event: InputEvent) -> void:
	if not held_item: return
	if event.is_action_pressed("rotate item"):
		hold_rotate = not hold_rotate
		return
	if event.is_action_pressed("escape"):
		held_item=null
		return


func try_move_item_to(item:Item, destination:Item.ContainerDetails) -> void:
	var container := destination.container
	if not container.can_fit_at(item,destination.slot): return
	item.container_details.container.remove_item(item, item.container_details.slot)
	container.put_item(item,destination.slot, destination.rotated)
	if item == held_item: held_item=null
