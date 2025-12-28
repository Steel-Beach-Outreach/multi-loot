class_name ItemContainer extends RefCounted

var grid_size:Vector2i
var whitelist:Array = []
var blacklist:Array = []
var contents:Array[Array]

signal changed

func _init(size:Vector2i=Vector2i(5,5)) -> void:
	grid_size=size
	contents.resize(size.x)
	for i in size.x:
		var temp:Array[Item] = []
		temp.resize(size.y)
		temp.fill(null)
		contents[i]=temp
	
func put_item(item:Item, coordinates:Vector2i, rotated:bool):
	contents[coordinates.x][coordinates.y]=item
	item.container_details=Item.ContainerDetails.new(self, coordinates, rotated)
	changed.emit()

func can_fit_at(_item:Item, location:Vector2i) -> bool:
	return contents[location.x][location.y]==null

func remove_item(item:Item, slot:Vector2i) -> void:
	assert(contents[slot.x][slot.y] == item)
	contents[slot.x][slot.y]=null
	changed.emit()
