extends CharacterBody2D
class_name Settler


var direction: Vector2 
var target_pos: Vector2 
var selected: bool = false
var resource_focus: MapResource
var is_target_resource: bool = false
var exploiting_resource: Dictionary = {"active": false, "type": null}
var spawn_day: int = 0
@export var life_expectancy: int = 500
@export var speed: float = 50.0
@export var food_consumption: float = 0.0
@onready var panel: Panel = $Panel
@onready var body: AnimatedSprite2D = $Body
@onready var navigation: NavigationAgent2D = $Navigation
@onready var light: PointLight2D = $Light
@onready var sfx_player: AudioStreamPlayer2D = $SfxPlayer

func animation() -> void:
	if exploiting_resource["active"] == true:
		match exploiting_resource.get("type"):
			MapResourceStats.Type.WOOD:
				body.play("felling")
			MapResourceStats.Type.EGG:
				body.play("felling")
			MapResourceStats.Type.FOOD:
				body.play("collecting")
	else:
		if navigation.is_navigation_finished():
			body.play("idle")
		else:
			body.play("moving")
		
		if velocity.x > 0.0:
			body.flip_h = false
		if velocity.x < 0.0:
			body.flip_h = true

func move() -> void:
	if !navigation.is_navigation_finished():
		direction = global_position.direction_to(navigation.get_next_path_position()).normalized()
		velocity = direction * speed
		move_and_slide()

func set_selected(i : bool) -> void:
	selected = i
	if i:
		panel.visible = true
	else:
		panel.visible = false

func set_resource_focus(resource: MapResource) -> void:
	resource_focus = resource
	target_pos = resource.global_position
	is_target_resource = true
	
func path() -> void:
	if Input.is_action_just_pressed("right_click") and selected:
		if is_target_resource:
			is_target_resource = false
		else:
			resource_focus = null
			target_pos = get_global_mouse_position()

func manage_light(action: bool) -> void:
	if light:
		var tween: Tween = create_tween()
		match action:
			
			true:
				tween.tween_property(light, "energy", 0.0, 5.0)
			false:
				tween.tween_property(light, "energy", 0.5, 5.0)
		
func _input(_event: InputEvent) -> void:
	path()

func _physics_process(_delta: float) -> void:
	if target_pos:
		navigation.target_position = target_pos 
	move()
	animation()


func _on_body_animation_finished() -> void:
	sfx_player.pitch_scale = randf_range(0.6, 0.8)
	sfx_player.volume_db = 0.0
	match body.animation:
		"moving":
			sfx_player.volume_db = -5.0
			sfx_player.stream = preload("res://Assets/Sounds/steps_sound.wav")
			sfx_player.play()	
		"felling":
			if resource_focus:
				sfx_player.volume_db = 5.0
				sfx_player.stream = preload("res://Assets/Sounds/fell_sound.wav")
				sfx_player.play()
				resource_focus.animation_player.play("exploiting")
		"collecting":
			if resource_focus:
				sfx_player.pitch_scale = randf_range(0.6, 0.8)
				sfx_player.volume_db = -5.0
				sfx_player.stream = preload("res://Assets/Sounds/collecting_sound.wav")
				sfx_player.play()
				resource_focus.animation_player.play("exploiting")
