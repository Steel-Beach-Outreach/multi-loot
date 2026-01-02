class_name LootWindow extends PanelContainer

@export var container_representation_path:NodePath

@onready var container_representation: ContainerRepresentationGUI = get_node(container_representation_path)


func _on_close_button_pressed() -> void:
	LootGlobal.open_container(container_representation.container)
