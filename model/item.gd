class_name Item extends Node


class ContainerDetails:
	var container:ItemContainer
	var slot:Vector2i
	var rotated:bool=false
	func _init(_container:ItemContainer, _slot:Vector2i, _rotated:bool):
		container=_container
		slot=_slot
		rotated = _rotated
	func can_take_item(item:Item) -> StringName:
		return container.consider_placement_at(item, slot, rotated)

var container_details:ContainerDetails = null

var item_id:int
var stack_size:int = 1
var weight:float
var definition:ItemDefinition:
	get:
		return LootConfiguration.item_list[item_id]
var sprite:Texture2D:
	get:
		return definition.sprite
var container:ItemContainer

func _init(_item_id:int=0) -> void:
	item_id = _item_id
	if definition is ContainerItem:
		container = ItemContainer.new(definition.internal_grid_size)
		container.container_item = self
