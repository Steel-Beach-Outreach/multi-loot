class_name ItemRepresentation extends TextureButton

static var dragging=null
var item:Item




func _on_pressed() -> void:
	if dragging:return
	dragging=self
