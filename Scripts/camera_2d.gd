extends Camera2D

const speed: float =  10.0
var direction: Vector2 

func move_with_keys() -> void:
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_bottom").normalized()
	position += direction * speed

func apply_zoom() -> void:
	if Input.is_action_pressed("zoom_in"):
		zoom += Vector2(0.05, 0.05)
	if Input.is_action_pressed("zoom_out"):
		zoom -= Vector2(0.05, 0.05)
	zoom = zoom.clamp(Vector2(0.5, 0.5), Vector2(2.0, 2.0))

func _input(_event: InputEvent) -> void:
	apply_zoom()

func _physics_process(_delta: float) -> void:
	move_with_keys()
	
	
