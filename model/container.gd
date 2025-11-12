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
	
func put_item(item:Item, coordinates:Vector2i):
	contents[coordinates.x][coordinates.y]=item
	changed.emit()
