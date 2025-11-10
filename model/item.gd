class_name Item extends Node

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
