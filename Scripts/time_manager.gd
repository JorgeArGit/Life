extends Node
class_name TimeManager

@onready var days: Label = $"../UI/ResourceLabelsContainer/Days"
@onready var day_timer: Timer = $DayTimer
@onready var night_timer: Timer = $NightTimer
@onready var light: DirectionalLight2D = $"../Light"
@export var settler_container: SettlersContainer
@onready var time_progress: TextureProgressBar = $"../UI/ResourceLabelsContainer/TimeProgress"
@onready var warning: Warning = $"../UI/Warning"
@onready var buildings: Buildings = $"../Buildings"


var days_amount: int = 0
signal new_day

func _ready() -> void:
	day_night_cycle(true)
	time_progress.max_value = day_timer.wait_time
	
func day_night_cycle(action: bool) -> void:
	var tween: Tween = create_tween()
	tween.set_parallel()
	match action:
		true:
			tween.tween_property(light, "energy", 0.0, 5.0)
			tween.tween_property(time_progress, "tint_progress", Color(1.0, 0.925, 0.153), 5.0)
			settler_container.light_settlers(action)
		false:
			tween.tween_property(light, "energy", 0.85, 5.0)
			tween.tween_property(time_progress, "tint_progress", Color(0.514, 0.463, 0.612), 5.0)
			settler_container.light_settlers(action)
			
func _on_timer_timeout() -> void:
	days_amount += 1
	settler_container.free_all_settlers()
	new_day.emit()
	days.text = "Day: " + str(days_amount) + "/" + "30"
	day_night_cycle(true)
	night_timer.start()
	buildings.use_farms()
	if days_amount == 30 or settler_container.get_children().size() == 0:
		warning.show_warning("You lost!")
	

func _on_night_timer_timeout() -> void:
	day_night_cycle(false)

func _physics_process(delta: float) -> void:
	time_progress.value = abs(day_timer.time_left - day_timer.wait_time)
