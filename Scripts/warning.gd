extends Label
class_name Warning

func show_warning(warning: String) -> void:
	text = warning
	visible = true
	await get_tree().create_timer(2).timeout
	visible = false
	
