class_name ContainerRepresentationGUI extends Control

@export var item_representation_scene:PackedScene

const grid_color:=Color(0.245, 0.245, 0.245, 1.0)

var container:ItemContainer = ItemContainer.new()
static var grid_size_plus_one := LootConfiguration.grid_size+Vector2i.ONE


func _ready() -> void:
	container.changed.connect(populate_representations)
	custom_minimum_size=grid_size_plus_one*container.grid_size
	container.changed.connect(queue_redraw)
	container.put_item(Item.new(), Vector2i.ZERO, false)
	container.put_item(Item.new(1), Vector2i.ONE, false)

func populate_representations():
	for child in get_children():
		child.queue_free()
	for x in container.grid_size.x:
		for y in container.grid_size.y:
			var item:Item = container.contents[x][y]
			if item:
				var rep:ItemRepresentation = item_representation_scene.instantiate()
				rep.item=item
				rep.set_position.call_deferred(Vector2i(x,y)*grid_size_plus_one)
				add_child(rep)
	
func _process(_delta: float) -> void:
	if mouse_in: queue_redraw()

func _draw() -> void:
	for x in container.grid_size.x+1:
		draw_line(Vector2i(x*grid_size_plus_one.x,0),\
		Vector2i(x*grid_size_plus_one.x,\
		grid_size_plus_one.y*container.grid_size.y+0),\
		grid_color)

	for y in container.grid_size.y+1:
		draw_line(Vector2i(0, y*grid_size_plus_one.y),\
		Vector2i(grid_size_plus_one.x*container.grid_size.x+0,\
		y*grid_size_plus_one.y),\
		grid_color)
	
	if mouse_in and LootGlobal.held_item:
		var grid_x :int = floor((get_local_mouse_position().x - LootGlobal.hold_offset.x) / grid_size_plus_one.x)
		var grid_y :int = floor((get_local_mouse_position().y - LootGlobal.hold_offset.y) / grid_size_plus_one.y)
		if grid_x >= container.grid_size.x or grid_x < 0: return
		if grid_y >= container.grid_size.y or grid_y < 0: return
		var to_place_rotated:bool = LootGlobal.held_item.container_details.rotated != LootGlobal.hold_rotate
		var proposed_container_details:=Item.ContainerDetails.new(container, Vector2i(grid_x, grid_y), to_place_rotated)
		var can_fit:bool = proposed_container_details.can_take_item(LootGlobal.held_item)
		draw_rect(Rect2(Vector2(grid_x*grid_size_plus_one.x, grid_y*grid_size_plus_one.y), Vector2(LootConfiguration.grid_size)),Color.GREEN if can_fit else Color.RED, true)
		if not LootGlobal.held_item:return
		if not can_fit: return
		if Input.is_action_just_released(LootGlobal.held_action):
			
			LootGlobal.try_move_item_to(LootGlobal.held_item,proposed_container_details)


var mouse_in:bool
func _on_mouse_entered() -> void:
	mouse_in=true
	queue_redraw()


func _on_mouse_exited() -> void:
	mouse_in=false
	queue_redraw()
