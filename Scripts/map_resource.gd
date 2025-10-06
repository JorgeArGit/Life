extends StaticBody2D
class_name MapResource

var focus : bool = false
var current_settlers: Array
@export var stats: MapResourceStats
@onready var settler_detection: Area2D = $SettlerDetection
@onready var panel: Panel = $Panel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sfx_player: AudioStreamPlayer2D = $SfxPlayer
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar

signal resource_selected
signal resource_obtained(amount: float, type: int)
signal resource_freed

func _ready() -> void:
	texture_progress_bar.max_value = stats.resource_amount
	texture_progress_bar.value = stats.resource_amount

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("right_click") and focus:
		resource_selected.emit()

func exploit_resource() -> void:
	while !current_settlers.is_empty() and stats.resource_amount >= stats.amount_per_second:
		texture_progress_bar.visible = true
		await get_tree().create_timer(1).timeout
		if is_instance_valid(current_settlers[0]):
			for settler: Settler in current_settlers:
				if settler.resource_focus != self:
					current_settlers.erase(settler)
					settler.exploiting_resource = {"active": false, "type": null}
		else:
			return
		var amount_exploited: float = stats.amount_per_second * current_settlers.size()
		if amount_exploited >= stats.resource_amount:
			amount_exploited = stats.resource_amount
		stats.set_resource_amount(amount_exploited)
		texture_progress_bar.value = stats.resource_amount
		resource_obtained.emit(amount_exploited, stats.type)
	if stats.resource_amount <= 0.0:
		if is_instance_valid(current_settlers[0]):
			for settler: Settler in current_settlers:
				settler.exploiting_resource = {"active": false, "type": null}
			sfx_player.pitch_scale = randf_range(1.0, 1.2)
		sfx_player.play()
		animation_player.play("falling")
		await animation_player.animation_finished
		resource_freed.emit()
		queue_free()

func _on_settler_detection_body_entered(body: Node2D) -> void:
	if body is Settler and body.resource_focus == self:
		var settler: Settler = body
		if settler not in current_settlers:
			current_settlers.append(settler)
		settler.exploiting_resource = {"active": true, "type": stats.type}
		if current_settlers.size() == 1:
			exploit_resource()

func _on_settler_detection_mouse_entered() -> void:
	focus = true
	panel.visible = true
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _on_settler_detection_mouse_exited() -> void:
	focus = false
	panel.visible = false
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
