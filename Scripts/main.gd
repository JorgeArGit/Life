extends Node
class_name Main

var wood_amount: float = 0.0
@onready var light: DirectionalLight2D = $Light
@onready var crt_shader: ColorRect = $UI/CrtShader


func _ready() -> void:
	light.energy = 0.75
	crt_shader.visible = false

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

func set_wood_amount() -> void:
	pass
	
