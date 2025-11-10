class_name ContainerRepresentationGUI extends Control

const grid_color:=Color(0.245, 0.245, 0.245, 1.0)

var container:ItemContainer = ItemContainer.new()
func _ready() -> void:
	container.changed.connect(queue_redraw)
	container.contents[0][0] = Item.new()
	

func _draw() -> void:
	var grid_size_plus_one := LootConfiguration.grid_size+Vector2i.ONE
	custom_minimum_size=grid_size_plus_one*container.grid_size
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
	
	for x in container.grid_size.x:
		for y in container.grid_size.y:
			var item:Item = container.contents[x][y]
			if item:
				draw_texture(item.sprite,Vector2i(x,y)*grid_size_plus_one)
