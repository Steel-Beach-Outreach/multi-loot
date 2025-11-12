extends Control

var held_item:Item = null
var hold_offset:=Vector2.ZERO
var held_action:String = ""


func _ready() -> void:
	z_index=1000
	
func _draw() -> void:
	if held_item:
		draw_texture(held_item.sprite,  get_viewport().get_mouse_position()-hold_offset, Color.WHITE)
	
func _process(_delta: float) -> void:
	queue_redraw()

func _input(event: InputEvent) -> void:
	if not held_item: return
	if event.is_action_released(held_action):
		pass
		#print(event.position)
		#return
		#held_item=null
