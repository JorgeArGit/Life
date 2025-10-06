extends Node
class_name SettlersContainer

@onready var settlers_array: Array = self.get_children()
@export var resource_manager: ResourceManager
@export var time_manager: TimeManager
@onready var population: Label = $"../UI/ResourceLabelsContainer/Population"
var settler_scene: PackedScene = preload("res://Scenes/Settler/settler.tscn")
var total_population: int = 0

func _ready() -> void:
	total_population = get_children().size()
	population.text = "Population: " + str(total_population)
	free_all_settlers()
	pass

func any_settler_selected() -> Array:
	var array : Array = []
	settlers_array = get_children()
	for settler : Settler in settlers_array:
		if settler.selected:
			array.append(settler)
	return array

func light_settlers(action: bool) -> void:
	settlers_array = get_children()
	for settler : Settler in settlers_array:
		settler.manage_light(action)
	

func free_random_settlers() -> void:
	settlers_array = get_children()
	if settlers_array.size() != 0:
		var settler: Settler = settlers_array.pick_random()
		settlers_array.erase(settler)
		settler.free()
	settlers_array = get_children()
	

func free_all_settlers() -> void:
	settlers_array = get_children()
	if get_children().size() != 0:
		for settler: Settler in get_children():
			if time_manager.days_amount - settler.spawn_day == settler.life_expectancy:
				settlers_array.erase(settler)
				settler.free()
	settlers_array = get_children()
	

func get_food_consumption() -> float:
	var total: float = 0.0
	if settlers_array.size() != 0:
		for settler: Settler in settlers_array:
			total += settler.food_consumption
	return -total

func spawn_settlers(spawn_pos: Vector2, necessary_food: float) -> void:
	if resource_manager.food_amount >= necessary_food:
		var new_settler: Settler = settler_scene.instantiate()
		new_settler.global_position = spawn_pos
		new_settler.spawn_day = time_manager.days_amount
		add_child(new_settler)
		total_population = get_children().size()
		population.text = "Population: " + str(total_population)
		resource_manager.set_resource_amount(-necessary_food, MapResourceStats.Type.FOOD)
