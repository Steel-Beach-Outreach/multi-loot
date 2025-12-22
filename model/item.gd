class_name Item extends Node


class ContainerDetails:
	var container:ItemContainer
	var slot:Vector2i
	func _init(_container:ItemContainer, _slot:Vector2i):
		container=_container
		slot=_slot

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

func _init(_item_id:int=0) -> void:
	item_id = _item_id
