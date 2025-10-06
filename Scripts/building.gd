extends StaticBody2D
class_name Building

signal building_placed(size: Vector2)
@export var tilemap_size: Vector2 
@onready var parent: Buildings = get_parent()
var focus: bool = false
@onready var ui: CanvasLayer = $UI
@onready var panel: Panel = $Panel

signal ui_showed

func _ready() -> void:
	parent.connect_building()
	building_placed.emit(tilemap_size)

func show_hide_ui() -> void:
	if Input.is_action_just_pressed("left_click") and focus and !ui.visible:
		ui.visible = true
		ui_showed.emit()
	elif Input.is_action_just_pressed("left_click") and focus and ui.visible:
		ui.visible = false


func _input(event: InputEvent) -> void:
	show_hide_ui()
		
func _on_mouse_entered() -> void:
	focus = true
	panel.visible = true
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	
func _on_mouse_exited() -> void:
	focus = false
	panel.visible = false
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	
