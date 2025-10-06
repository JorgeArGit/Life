extends Control
class_name BuildMenu

@onready var build_button: TextureButton = $HBoxContainer/BuildButton
@onready var builds_container: HBoxContainer = $HBoxContainer/BuildsContainer
var build_mode: bool = false
signal build(type: int)
signal stop


func _on_build_button_pressed() -> void:
	if builds_container.visible:
		builds_container.visible = false
		stop.emit()
	else:
		builds_container.visible = true
		

func _on_build_button_mouse_entered() -> void:
	build_button.scale = Vector2(1.1, 1.1)
	build_mode = false

func _on_build_button_mouse_exited() -> void:
	build_button.scale = Vector2(1.0, 1.0)

func _on_exit_button_pressed() -> void:
	builds_container.visible = false
	
func _on_nest_button_pressed() -> void:
	build.emit(Buildings.Types.NEST)

func _on_farm_button_pressed() -> void:
	build.emit(Buildings.Types.FARM)

func _on_nest_button_mouse_entered() -> void:
	build_mode = true

func _on_farm_button_mouse_entered() -> void:
	build_mode = true
