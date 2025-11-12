class_name ContainerRepresentationGUI extends Control

@export var item_representation_scene:PackedScene

const grid_color:=Color(0.245, 0.245, 0.245, 1.0)

var container:ItemContainer = ItemContainer.new()
static var grid_size_plus_one := LootConfiguration.grid_size+Vector2i.ONE


func _ready() -> void:
	container.changed.connect(populate_representations)
	custom_minimum_size=grid_size_plus_one*container.grid_size
	container.changed.connect(queue_redraw)
	container.put_item(Item.new(), Vector2i.ZERO)

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
	
func _gui_input(event: InputEvent) -> void:
	if not LootGlobal.held_item:return
	if not event.is_action_released(LootGlobal.held_action): return
	print(event.as_text())
	print(event.position)
	var grid_x :int = floor(get_local_mouse_position().x / LootConfiguration.grid_size.x)
	var grid_y :int = floor(get_local_mouse_position().y / LootConfiguration.grid_size.y)
	container.put_item(LootGlobal.held_item, Vector2i(grid_x, grid_y))

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
	
	if mouse_in:
		var grid_x :int = floor(get_local_mouse_position().x / grid_size_plus_one.x)
		var grid_y :int = floor(get_local_mouse_position().y / grid_size_plus_one.y)
		draw_rect(Rect2(Vector2(grid_x*grid_size_plus_one.x, grid_y*grid_size_plus_one.y), Vector2(LootConfiguration.grid_size)),Color.GREEN,true)

var mouse_in:bool
func _on_mouse_entered() -> void:
	mouse_in=true
	queue_redraw()


func _on_mouse_exited() -> void:
	mouse_in=false
	queue_redraw()
