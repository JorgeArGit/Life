extends Node2D
class_name SelectionRect

var start_pos: Vector2
var end_pos: Vector2
var rect: Rect2
var is_drawing: bool
var width: float
var settlers_array : Array

@export var settlers_container: SettlersContainer 

func _ready() -> void:
	settlers_array = settlers_container.settlers_array

func _draw() -> void:
	var rect_pos: Vector2 = start_pos
	var rect_size: Vector2 = end_pos - start_pos
	rect = Rect2(rect_pos, rect_size)
	rect = rect.abs()
	draw_rect(rect, Color(1.0, 0.0, 1.0, 0.314), false, 1.0)

func set_rect_values(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			is_drawing = true
			start_pos = get_global_mouse_position()
			end_pos = get_global_mouse_position()
		if event.is_released() and event.button_index == MOUSE_BUTTON_LEFT:
			is_drawing = false
			start_pos = Vector2.ZERO
			end_pos = Vector2.ZERO
			queue_redraw()
	if event is InputEventMouseMotion and is_drawing:
		end_pos = get_global_mouse_position()
		queue_redraw()

func manage_select() -> void:
	settlers_array = settlers_container.get_children()
	if settlers_array.size() != 0:
		for settler : Settler in settlers_array:
				settler.set_selected(false)

func select_settlers(_event: InputEvent) -> void:
	settlers_array = settlers_container.get_children()
	if rect and settlers_array.size() != 0:
		for settler: Settler in settlers_array:
			if rect.has_point(settler.global_position):
				settler.set_selected(true)
			else:
				settler.set_selected(false)
	else:
		if Input.is_action_just_pressed("left_click"):
			manage_select()

func _input(event: InputEvent) -> void:
	set_rect_values(event)
	select_settlers(event)
	
