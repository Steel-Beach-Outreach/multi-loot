class_name ItemContainer extends RefCounted

var grid_size:Vector2i
var whitelist:Array = []
var blacklist:Array = []
var contents:Array[Array]
var filled_with:Array[Array]
var container_item:Item = null

signal changed


func get_item_dimensions(item:Item, rotated:bool) -> Vector2i:
	var item_dimensions:Vector2i = item.definition.dimensions
	if rotated: item_dimensions = transposed_vector2i(item_dimensions)
	return item_dimensions

static func transposed_vector2i(vector:Vector2i) -> Vector2i:
	vector.x ^= vector.y
	vector.y ^= vector.x
	vector.x ^= vector.y
	return vector

func write_to_slots(item_dimensions:Vector2i, location:Vector2i, set_to:Item, should_be:Item=null) -> void:
	assert(contents[location.x][location.y] == should_be)
	contents[location.x][location.y]=set_to
	for x in item_dimensions.x:
		for y in item_dimensions.y:
			var test_location := Vector2i(location.x+x, location.y+y)
			assert(filled_with[test_location.x][test_location.y] == should_be)
			filled_with[test_location.x][test_location.y] = set_to

func _init(size:Vector2i=Vector2i(5,5)) -> void:
	grid_size=size
	contents.resize(size.x)
	filled_with.resize(size.x)
	for i in size.x:
		var temp:Array[Item] = []
		var temp2:Array[Item] = []
		temp.resize(size.y)
		temp2.resize(size.y)
		temp.fill(null)
		temp2.fill(null)
		contents[i]=temp
		filled_with[i]=temp2
	put_item(Item.new(), Vector2i.ZERO, false)
	put_item(Item.new(1), Vector2i.ONE, false)
	
	
func put_item(item:Item, coordinates:Vector2i, rotated:bool):
	var item_dimensions: = get_item_dimensions(item, rotated)
	write_to_slots(item_dimensions, coordinates, item, null)
	item.container_details=Item.ContainerDetails.new(self, coordinates, rotated)
	changed.emit()

func single_square_valid_item_placement(item:Item, location:Vector2i) -> bool:
	if location.x >= grid_size.x or location.x < 0: return false
	if location.y >= grid_size.y or location.y < 0: return false
	if filled_with[location.x][location.y]==null: return true
	return filled_with[location.x][location.y]==item

func can_fit_at(item:Item, location:Vector2i, rotated:bool) -> bool:
	var item_dimensions: = get_item_dimensions(item, rotated)
	for x in item_dimensions.x:
		for y in item_dimensions.y:
			var test_location = Vector2i(location.x+x, location.y+y)
			if not single_square_valid_item_placement(item, test_location): return false
	return true

func does_item_contain_me(item:Item) -> bool:
	assert(item.definition is ContainerItem)
	var search:ItemContainer = self
	while search.container_item != null:
		if search.container_item == item: return true
		assert(search != search.container_item.container_details.container, "item already contained in itself")
		search = search.container_item.container_details.container
	return false

func consider_placement_at(item:Item, location:Vector2i, rotated:bool) -> StringName:
	if not can_fit_at(item, location, rotated): return &"Doesn't fit"
	if item.definition is ContainerItem:
		if does_item_contain_me(item): return &"Can't be stored in itself"
	return &""

func remove_item(item:Item) -> void:
	var item_dimensions: = get_item_dimensions(item, item.container_details.rotated)
	write_to_slots(item_dimensions, item.container_details.slot, null, item)
	changed.emit()
