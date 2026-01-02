extends Control

var held_item:Item = null:
	set(val):
		held_item=val
		hold_rotate=false
var held_action:String = ""
var hold_rotate:bool = false
var held_window:LootWindow = null
var held_window_offset:Vector2

func _ready() -> void:
	z_index=1000

func _draw() -> void:
	if held_item:
		if not Input.is_action_pressed(held_action):
			lose_item.call_deferred()
			return
		var to_draw_rect:Rect2 = Rect2(get_viewport().get_mouse_position(),held_item.sprite.get_size())
		if held_item.container_details.rotated != hold_rotate:
			draw_set_transform(Vector2.ZERO,PI/2)
			var transposer := to_draw_rect.position.x
			to_draw_rect.position.x = to_draw_rect.position.y
			to_draw_rect.position.y = -transposer
		to_draw_rect.position-=held_item.sprite.get_size()/2
		draw_texture_rect(held_item.sprite, to_draw_rect, false, Color.WHITE)
	
func _process(_delta: float) -> void:
	if held_window:
		if not Input.is_action_pressed("drag item"):
			held_window = null
		else:
			held_window.position = get_viewport().get_mouse_position()-held_window_offset
	queue_redraw()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("rotate item"):
		if not held_item: return
		hold_rotate = not hold_rotate
		return
	if event.is_action_pressed("escape"):
		if held_item:
			lose_item()
			return
		var count := loot_window_parent.get_child_count()
		if count == 0: return
		loot_window_parent.get_child(count-1)._on_close_button_pressed()

func lose_item() -> void:
	held_item = null

const window_scene:PackedScene = preload("res://client/loot_window.tscn")

var loot_window_parent:Control = null
var opened_containers:Dictionary[ItemContainer, LootWindow] = {}
func open_container(container:ItemContainer) -> void:
	if container in opened_containers:
		opened_containers[container].queue_free()
		opened_containers.erase(container)
		return
	var new_window:LootWindow = window_scene.instantiate()
	opened_containers[container] = new_window
	var container_representation:ContainerRepresentationGUI = new_window.get_node(new_window.container_representation_path)
	loot_window_parent.add_child(new_window)
	container_representation.container = container
	new_window.position = Vector2(200,200)
	

func try_move_item_to(item:Item, destination:Item.ContainerDetails) -> void:
	var container := destination.container
	if destination.can_take_item(item) != &"": return
	item.container_details.container.remove_item(item)
	container.put_item(item,destination.slot, destination.rotated)
	if item == held_item: held_item=null
