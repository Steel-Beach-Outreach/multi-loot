extends Control

func _ready() -> void:
	LootGlobal.loot_window_parent = self
	for i:LootWindow in get_children():
		i.container_representation.container=ItemContainer.new()
		i.container_representation.container.put_item(Item.new(2), Vector2i.ONE*3, false)
